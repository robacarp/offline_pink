module Monitoring
  class ResultLogger
    DEFAULT_SEVERITY = LogEntry::Severity.new :notice

    getter monitor_event : Time
    getter results : Array(ResultHostLogger)

    def initialize(@domain : Domain, @logger : Log)
      @monitor_event = Time.utc.at_beginning_of_second
      @results = [] of ResultHostLogger
    end

    def log(message : String, severity : LogEntry::Severity = DEFAULT_SEVERITY)
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

    def log(message : String, severity : LogEntry::Severity = DEFAULT_SEVERITY)
      log message, severity do
      end
    end

    def log(message : String, severity : LogEntry::Severity = DEFAULT_SEVERITY, *, from monitor : Monitor)
      log message, severity do |entry|
        entry.monitor_id.value = monitor.id
      end
    end

    def for(host : Host)
      ResultHostLogger.new(self, host).tap do |host_logger|
        results << host_logger
      end
    end

    def successful_results : Array(ResultHostLogger)
      results.select &.successful?
    end

    def failed_results : Array(ResultHostLogger)
      results.select &.failed?
    end
  end
end
