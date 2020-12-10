module Monitoring
  abstract class Base
    getter result : Result
    getter host : Host

    private getter monitor : Monitor::Any
    private getter logger : LogArchiver
    delegate :successful!, :failed!, to: @result

    def self.check(host : Host, with monitor : Monitor::Any, logger : LogArchiver) : Result
      instance = new(host, monitor, logger)
      instance.check
      instance.result
    end

    def initialize(@host : Host, @monitor : Monitor::Any, @logger : LogArchiver)
      @result = Result.new host, monitor
    end

    def log(message : String, severity : LogEntry::Severity = LogArchiver::DEFAULT_SEVERITY)
      logger.emit "#{log_identifier} #{message}", severity, from: monitor
    end

    protected abstract def check : Nil

    def log_identifier : String
      ""
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

