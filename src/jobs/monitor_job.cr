require "icmp"

class MonitorJob < Mosquito::QueuedJob
  params(domain : Domain | Nil)

  def perform
    log "Starting monitor for Domain##{present_domain.id} #{present_domain.name}"
    @start_time = Time.now
    resolver = HostResolver.lookup_hosts present_domain
    resolve_info resolver
    log_missing_hosts resolver

    results = resolver.hosts.map do |host|
      domain.monitors.map do |monitor|
        result = case monitor.monitor_type
        when Monitor::VALID_TYPES[:ping]
          check_ping host, monitor
        when Monitor::VALID_TYPES[:http]
          check_http host, monitor
        end

        next if result.nil?

        result.domain_id = monitor.domain_id
        result.host_id = host.id
        result.monitor_type = monitor.monitor_type
        result
      end
    end.compact

    results.flatten.compact.map &.save

  ensure
    log "Finished monitor for Domain##{present_domain.id} #{present_domain.name}"
  end

  def check_ping(host : Host, monitor : Monitor) : MonitorResult?
    log "Pinging #{host.address}"
    return unless address = host.address

    statistics = ICMP::Ping.ping(address)
    log "Ping time: #{statistics[:average_response]}"

    MonitorResult.new(
      ok: statistics[:success] > 0,
      ping_response_time: statistics[:average_response]
    )
  end

  # Job failed! Raised Errno: connect: Network is down

  def check_http(host : Host, monitor : Monitor) : MonitorResult?
    url = "#{host.address}#{monitor.http_path}"
    headers = HTTP::Headers{ "Host" => "#{monitor.domain.name}" }

    log "GETing #{url} host=#{monitor.domain.name}"

    # TODO prevent big pages from taking down the worker? Limit to 1KB or so?
    # TODO handle OpenSSL::SSL::Error: SSL_connect: error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed

    start_time = Time.now
    response = HTTP::Client.get url, headers
    response_time = Time.now - start_time

    log "response code: #{response.status_code}"

    result = MonitorResult.new(
      ok: response.status_code == monitor.http_expected_status_code,
      http_response_code: response.status_code,
      http_response_time: response_time.milliseconds.to_f32,
    )

    if search_text = monitor.http_expected_content
      unless search_text.blank?
        index = response.body.lines.join(" ").index search_text
        result.http_content_found = ! index.nil?
        result.ok = result.ok && result.http_content_found
      end
    end

    result
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
