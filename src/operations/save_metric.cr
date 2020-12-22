class SaveMetric < Metric::SaveOperation
  permit_columns(
    name,
    units,
    success,
    integer_value,
    float_value,
    boolean_value,
    string_value
  )

  needs monitor : Monitor

  before_save do
    monitor_id.value = monitor.id
    set_metric_type

    if success.value == true
      validate_exactly_one_filled(
        boolean_value,
        integer_value,
        float_value,
        string_value
      )

      validate_required units
    end

    validate_required name
  end

  def set_metric_type
    case
    when success.value == false
      metric_type.value = Metric.none

    when boolean_value.value.present?
      metric_type.value = Metric.bool

    when float_value.value.present?
      metric_type.value = Metric.float

    when integer_value.value.present?
      metric_type.value = Metric.integer

    when string_value.value.present?
      metric_type.value = Metric.string

    else
      message = <<-MSG
      Unable to determine metric_type for
        bool: #{boolean_value.value}
        float: #{float_value.value}
        integer: #{integer_value.value}
        string: #{string_value.value}
      MSG
      raise message
    end
  end
end
