module Monitoring
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
