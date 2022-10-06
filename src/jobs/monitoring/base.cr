module Monitoring
  abstract class Base
    getter host : Host

    private getter monitor : Monitor
    private getter logger : ResultHostLogger

    def self.check(host : Host, with monitor : Monitor, logger : ResultHostLogger)
      instance = new(host, monitor, logger)
      instance.check
    end

    delegate :failed!, to: @logger

    protected abstract def check : Nil

    def initialize(@host : Host, @monitor : Monitor, @logger : ResultHostLogger)
    end

    def config
      monitor.monitor_config
    end

    def log(message : String, severity : LogEntry::Severity = ResultLogger::DEFAULT_SEVERITY)
      logger.log "#{log_identifier} #{message}", severity, from: monitor
    end

    def save_metric(name : String, data : String | Float64 | Int32 | Bool, units : String, *, success = true)
      logger.save_metric monitor, name: name, data: data, units: units, success: success
    end

    def save_metric(name : String, data : Time::Span, *, success = true)
      logger.save_metric monitor, name: name, data: data, success: success
    end

    def save_failed_metric(name : String)
      logger.save_metric monitor, name: name, success: false
    end

    def log_identifier
      host.ip_address
    end

    def format_time(span : Time::Span) : String
      number = span.total_seconds
      unit = "s"

      case
      when span.total_milliseconds > 0
        number = span.total_milliseconds
        unit = "ms"
      when span.total_nanoseconds > 0
        number = span.total_nanoseconds
        unit = "ns"
      end

      "#{number.*(100).trunc./(100)}#{unit}"
    end
  end
end

