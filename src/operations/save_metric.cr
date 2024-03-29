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
    when boolean_value.value.present?
      metric_type.value = Metric::Type::Bool

    when float_value.value.present?
      metric_type.value = Metric::Type::Float

    when integer_value.value.present?
      metric_type.value = Metric::Type::Integer

    when string_value.value.present?
      metric_type.value = Metric::Type::String

    else
      metric_type.value = Metric::Type::None

    end
  end
end
