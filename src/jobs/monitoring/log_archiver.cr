class LogArchiver
  DEFAULT_SEVERITY = LogEntry::Severity.new :notice
  @monitor_event : Int64 = 0

  def initialize(@domain : Domain, @logger : Log)
    AppDatabase.run do |db|
      @monitor_event = db.scalar("SELECT NEXTVAL('log_entry_run_sequence')").as(Int64)
    end
  end

  def emit(message : String, severity : LogEntry::Severity = DEFAULT_SEVERITY)
    operation = LogEntry::SaveOperation.new(
      domain_id: @domain.id,
      text: message,
      severity: severity,
      monitor_event: @monitor_event
    )

    yield operation

    @logger.info { message }

    operation.save!
  end

  def emit(message : String, severity : LogEntry::Severity = DEFAULT_SEVERITY)
    emit message, severity do
    end
  end

  def emit(message : String, severity : LogEntry::Severity = DEFAULT_SEVERITY, *, from monitor : Monitor::Base)
    emit message, severity do |entry|
      case monitor
      when Monitor::Icmp
        entry.icmp_monitor_id.value = monitor.id
      when Monitor::Http
        entry.http_monitor_id.value = monitor.id
      else
        emit "could not resolve monitor type: #{monitor.class.name}"
        nil
      end
    end
  end
end
