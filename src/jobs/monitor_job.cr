class MonitorJob < Mosquito::QueuedJob
  params(domain_id : Int64)

  @_domain : Domain?
  @_resolver : Monitoring::HostResolver?
  @_log_archiver : LogArchiver?

  def log_archiver : LogArchiver
    @_log_archiver.not_nil!
  end

  def domain : Domain
    @_domain.not_nil!
  end

  def hosts : Array(Monitoring::Host)
    @_resolver.not_nil!.hosts
  end

  def setup_logs
    @_log_archiver = LogArchiver.new domain, Log
  end

  def log(message, severity = LogArchiver::DEFAULT_SEVERITY)
    if archiver = @_log_archiver
      archiver.emit message, severity
    else
      super message
    end
  end

  def log(severity = LogArchiver::DEFAULT_SEVERITY, &block)
    message = String.build do |builder|
      yield builder
    end
    log message, severity
  end

  def perform
    results = [] of Monitoring::Result

    log "Starting monitor for Domain##{domain_id} at #{Time.utc.to_s("%Y-%m-%d %H:%M:%S %:z")}"

    ensure_domain
    setup_logs
    log "DNS Name is: #{domain.name}"

    resolve_dns

    log do |l|
      l << "Found #{hosts.size} hosts: "
      l << hosts.map(&.ip_address).join(", ")
    end

    log do |l|
      l << "Monitors: "
      l << domain.monitors.map(&.summary).join("; ")
    end

    hosts.each do |host|
      domain.monitors.map do |monitor|
        case monitor
        when Monitor::Http
          results << Monitoring::Http.check host, with: monitor, logger: log_archiver

        when Monitor::Icmp
          results << Monitoring::Icmp.check host, with: monitor, logger: log_archiver

        else
          log "Unable to monitor a \"#{monitor.type}\" for #{domain_id} - Unknown monitor type"
          nil
        end
      end
    end
  ensure
    domain_name = ""
    domain.try { |domain_| domain_name = " (#{domain_.name})" }
    update_domain_health(results || [] of Monitoring::Result)
    log "Finished monitoring Domain##{domain_id}#{domain_name}"
  end

  def ensure_domain
    @_domain = DomainQuery.new
      .preload_icmp_monitors
      .preload_http_monitors
      .find domain_id
  end

  def resolve_dns
    @_resolver = resolver = Monitoring::HostResolver.lookup_hosts domain
    mark_domain_invalid("DNS failure, no hosts resolved") if resolver.hosts.empty?
  end

  def rescheduleable?
    false
  end

  def mark_domain_invalid(reason)
    Domain::SaveOperation.update domain, is_valid: false do |operation, domain|
      if operation.saved?
        log "Marking domain as invalid : #{reason}"
      else
        log <<-LOG
        Could not update domain##{domain.id}:
          - #{operation.errors.join("\n -")}
        LOG
      end
    end

    log reason, severity: LogEntry.fatal
  end

  def update_domain_health(results : Array(Monitoring::Result))
    status = Domain::Status.new :system_failure

    grouped_results = results.group_by &.success
    successful = grouped_results[true]?.try(&.size) || 0
    failed = grouped_results[false]?.try(&.size) || 0

    case
    when successful + failed == 0
      status = Domain::Status.new :un_checked
    when successful > 0 && failed > 0
      status = Domain::Status.new :degraded
    when successful == 0 && failed > 0
      status = Domain::Status.new :offline
    when successful > 0 && failed == 0
      status = Domain::Status.new :stable
    end

    save = Domain::SaveOperation.new(domain)
    save.status_code.value = status

    if log_archive = @_log_archiver
      save.last_monitor_event.value = log_archive.monitor_event
    end

    save.save!
  end
end
