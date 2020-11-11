class MonitorJob < Mosquito::QueuedJob
  params(domain_id : Int64)

  @_domain : Domain?
  @_resolver : Monitoring::HostResolver?

  def domain : Domain
    @_domain.not_nil!
  end

  def hosts : Array(Monitoring::Host)
    @_resolver.not_nil!.hosts
  end

  def perform
    log "Starting monitor for Domain##{domain_id}"

    ensure_domain
    log "DNS Name is: #{domain.name}"

    resolve_dns
    log "Found #{hosts.size} hosts:"

    hosts.each do |host|
      log "\t #{host.ip_address}"

      results = domain.monitors.map do |monitor|
        case monitor
        when Monitor::HTTP
          Monitoring::HTTP.check host, with: monitor

        when Monitor::ICMP
          Monitoring::ICMP.check host, with: monitor

        else
          log "Unable to monitor a \"#{monitor.type}\" for #{domain_id} - Unknown monitor type"
          nil
        end
      end

      results.compact.each do |result|
        result.log.each {|l| log l }
      end
    end

  ensure
    log "Finished monitor for Domain##{domain_id} (#{domain.name})"
  end

  def ensure_domain
    @_domain = DomainQuery.new
      .preload_icmp_monitors
      .preload_http_monitors
      .find domain_id
  end

  def resolve_dns
    @_resolver = resolver = Monitoring::HostResolver.lookup_hosts domain
  end

  # Job failed! Raised Errno: connect: Network is down

  def rescheduleable?
    false
  end
end
