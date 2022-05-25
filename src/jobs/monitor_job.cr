class MonitorJob < Mosquito::QueuedJob
  params(domain_id : Int64)

  alias ResultLogger = Monitoring::ResultLogger

  @_domain : Domain?
  @_resolver : Monitoring::HostResolver?
  @_result_logger : ResultLogger?
  @monitor_event : Int64 = 0

  def result_logger : ResultLogger
    @_result_logger.not_nil!
  end

  def domain : Domain
    @_domain.not_nil!
  end

  def hosts : Array(Monitoring::Host)
    @_resolver.not_nil!.hosts
  end

  def setup_logs
    @_result_logger = ResultLogger.new domain, Log
  end

  def create_monitor_event
    AppDatabase.run do |db|
      @monitor_event = db.scalar("SELECT NEXTVAL('log_entry_run_sequence')").as(Int64)
    end
  end


  def log(message, severity = ResultLogger::DEFAULT_SEVERITY)
    if archiver = @_result_logger
      archiver.log message, severity
    else
      super message
    end
  end

  def log(severity = ResultLogger::DEFAULT_SEVERITY, &block)
    message = String.build do |builder|
      yield builder
    end
    log message, severity
  end

  def perform
    log "Starting monitor for Domain##{domain_id} at #{Time.utc.to_s("%F %X.%6N")}"

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

      if domain.monitors.any?
        l << domain.monitors.map(&.summary).join("; ")
      else
        l << "none"
      end
    end

    domain.monitors.map do |monitor|
      log "#{monitor.monitor_type}:"

      hosts.each do |host|
        args = { host: host, with: monitor, logger: result_logger.for(host) }

        case monitor.monitor_type
        when Monitor::Type::Http
          Monitoring::Http.check(**args)

        when Monitor::Type::Icmp
          Monitoring::Icmp.check(**args)

        else
          raise "Unable to monitor a \"#{monitor.monitor_type}\" for domain##{domain_id} - Unknown monitor type for Monitor##{monitor.id}"
          nil
        end

      end
    end
  ensure
    domain_name = ""
    domain.try { |domain_| domain_name = " (#{domain_.name})" }
    update_domain_health
    log "Finished monitoring Domain##{domain_id}#{domain_name}"
  end

  def ensure_domain
    @_domain = DomainQuery.new
      .preload_monitors
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
    DomainOp::UpdateValidity.update domain, is_valid: false do |operation, domain|
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

  def update_domain_health
    status = Domain::Status.new :system_failure

    successful = result_logger.successful_results.size
    failed = result_logger.failed_results.size

    log "succesful #{successful} / failed #{failed}"

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

    save = DomainOp::UpdateHealth.new(domain)
    save.status_code.value = status

    if result_logger = @_result_logger
      save.last_monitor_event.value = result_logger.monitor_event
    end

    save.save!
  end
end
