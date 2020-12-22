module Monitoring
  abstract class Base
    getter result : Result
    getter host : Host

    private getter monitor : Monitor
    private getter logger : LogArchiver
    delegate :successful!, :failed!, to: @result

    def self.check(host : Host, with monitor : Monitor, logger : LogArchiver) : Result
      instance = new(host, monitor, logger)
      instance.check
      instance.result
    end

    def initialize(@host : Host, @monitor : Monitor, @logger : LogArchiver)
      @result = Result.new host, monitor
    end

    def config
      monitor.monitor_config
    end

    def log(message : String, severity : LogEntry::Severity = LogArchiver::DEFAULT_SEVERITY)
      logger.emit "#{log_identifier} #{message}", severity, from: monitor
    end

    def save_metric(name : String, data : String, units : String, *, success = true)
      SaveMetric.create! monitor, name: name, string_value: data, units: units, success: success
    end

    def save_metric(name : String, data : Float64, units : String, *, success = true)
      SaveMetric.create! monitor, name: name, float_value: data, units: units, success: success
    end

    def save_metric(name : String, data : Int32, units : String, *, success = true)
      SaveMetric.create! monitor, name: name, integer_value: data, units: units, success: success
    end

    def save_metric(name : String, data : Bool, *, success = true)
      SaveMetric.create! monitor, name: name, boolean_value: data, units: "boolean", success: success
    end

    def save_metric(name : String, data : Time::Span, *, success = true)
      save_metric name: name, data: data.milliseconds, units: "ms", success: success
    end

    def save_failed_metric(name : String)
      SaveMetric.create! monitor, name: name, success: false
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

