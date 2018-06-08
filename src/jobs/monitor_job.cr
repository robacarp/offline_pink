require "icmp"

class MonitorJob < Mosquito::QueuedJob
  params(domain : Domain | Nil)

  def perform
    log "Starting monitor for Domain##{present_domain.id} #{present_domain.name}"
    start_time = Time.now
    resolver = HostResolver.lookup_hosts present_domain
    resolve_info resolver
    log_missing_hosts resolver

    hosts = resolver.hosts

    results = hosts.map do |host|
      old_host_status = host.status

      host_results = domain.monitors.map do |monitor|
        result = case monitor.monitor_type
        when Monitor::VALID_TYPES[:ping]
          check_ping host, monitor
        when Monitor::VALID_TYPES[:http]
          check_http host, monitor
        end

        next if result.nil?

        result.tap do |r|
          r.domain_id      = monitor.domain_id
          r.host_id        = host.id
          r.monitor_id     = monitor.id
          r.monitor_type   = monitor.monitor_type
          r.run_start_time = start_time
          r.save
        end
      end.compact

      if host_results.all?(&.ok?)
        host.state = Host::Status::Up
      else
        host.state = Host::Status::Down
      end

      host.save

      host_results
    end

    host_statuses = hosts.map(&.state).uniq

    log "Hosts are #{host_statuses}"

    domain.state = Domain::Status::PartiallyDown
    domain.state = Domain::Status::Up   unless host_statuses.includes? Host::Status::Down
    domain.state = Domain::Status::Down unless host_statuses.includes? Host::Status::Up
    domain.save

    log "Domain is #{domain.state}"

  ensure
    log "Finished monitor for Domain##{present_domain.id} #{present_domain.name}"
  end

  def check_ping(host : Host, monitor : Monitor) : MonitorResult?
    log "Pinging #{host.address}"
    return unless address = host.address

    icmp = ICMP::Ping.new address
    statistics = icmp.ping timeout: 2 do |thing|
      # shhhhhh
    end

    success = statistics[:success] == 1

    if success
      log "Ping time: #{statistics[:average_response]}"

      MonitorResult.new(
        ok: true,
        ping_response_time: statistics[:average_response]
      )
    else
      log "Ping failure."

      MonitorResult.new(
        ok: false
      )
    end
  end

  # Job failed! Raised Errno: connect: Network is down

  def check_http(host : Host, monitor : Monitor) : MonitorResult?
    url = "#{monitor.http_protocol}#{host.address}#{monitor.http_path}"
    headers = HTTP::Headers{ "Host" => "#{monitor.domain.name}" }

    log "GETing #{url} host=#{monitor.domain.name}"

    # TODO prevent big pages from taking down the worker? Limit to 1KB or so?
    # TODO handle OpenSSL::SSL::Error: SSL_connect: error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed

    tls_config = OpenSSL::SSL::Context::Client.new
    tls_config.verify_mode = OpenSSL::SSL::VerifyMode::NONE

    client = if monitor.https?
      HTTP::Client.new "#{host.address}", tls: tls_config
    else
      HTTP::Client.new "#{host.address}"
    end

    client.connect_timeout = 2
    client.read_timeout = 2

    start_time = Time.now
    response = client.get "#{monitor.http_path}"
    response_time = Time.now - start_time

    log "response code: #{response.status_code}"

    result = MonitorResult.new(
      ok: response.status_code == monitor.http_expected_status_code,
      http_response_code: response.status_code,
      http_response_time: response_time.milliseconds.to_f32,
    )

    if monitor.search_content?
      if search_text = monitor.http_expected_content
        index = response.body.lines.join(" ").index search_text
        result.http_content_found = ! index.nil?
        result.ok = result.ok && result.http_content_found
      end
    end

    result
  rescue err : Errno
    case err.errno
    when Errno::ECONNREFUSED
      log "http connection refused"
    when Errno::ETIMEDOUT
      log "http connection timed out"
    else
      log "http check failed with errno #{err.errno}"
    end

    MonitorResult.new(ok: false)
  end

  def rescheduleable?
    false
  end

  def present_domain
    domain.not_nil!
  end

  def domain_name!
    present_domain.name.not_nil!
  end

  def resolve_info(resolver : HostResolver)
    log "#{resolver.hosts.size} hosts:"
    resolver.hosts.map(&.address).each do |address|
      log "\t #{address}"
    end

    log "#{resolver.new_hosts.size} new hosts:"
    resolver.new_hosts.map(&.address).each do |address|
      log "\t #{address}"
    end

    log "#{resolver.missing_hosts.size} hosts are no longer resolving:"
    resolver.missing_hosts.map(&.address).each do |address|
      log "\t #{address}"
    end
  end

  def log_missing_hosts(resolver : HostResolver)
    resolver.missing_hosts.each do |host|
      MonitorResult.new(
        domain_id: present_domain.id,
        host_id: host.id,
        monitor_type: MonitorResult::VALID_TYPES[:host],
        missing_host: true
      ).tap &.save
    end
  end
end
