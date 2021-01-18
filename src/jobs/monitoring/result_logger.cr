module Monitoring
  class ResultLogger
    DEFAULT_SEVERITY = LogEntry::Severity.new :notice

    getter monitor_event : Time
    getter results : Array(ResultHostLogger)

    def initialize(@domain : Domain, @logger : Log)
      @monitor_event = Time.utc
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

  class ResultHostLogger
    getter success : Bool = true

    private getter result_logger

    def initialize(@result_logger : ResultLogger, @host : Host)
    end

    delegate :log, to: @result_logger

    def save_metric(
      monitor : Monitor,
      name : String,
      data : String | Float64 | Int32 | Bool | Time::Span,
      units : String = "",
      success : Bool = true
    )

      metric = SaveMetric.new(
        monitor,
        name: name,
        success: success,
        units: units,
        monitor_event: result_logger.monitor_event
      )

      case data
      when String
        metric.string_value.value = data
      when Float64
        metric.float_value.value = data
      when Int32
        metric.integer_value.value = data
      when Bool
        metric.boolean_value.value = data
        metric.units.value = "boolean"
      when Time::Span
        metric.integer_value.value = data.milliseconds
        metric.units.value = "ms"
      end

      metric.save!
    end

    def save_metric(monitor : Monitor, name : String, *, success : Bool)
      SaveMetric.new(
        monitor,
        name: name,
        success: success,
        monitor_event: result_logger.monitor_event
      ).save!
    end

    protected def successful!
      @success = true
    end

    protected def failed!
      @success = false
    end

    def successful?
      @success == true
    end

    def failed?
      @success == false
    end
  end
end
