class MetricSerializer < BaseSerializer
  def initialize(@metric : Metric)
  end

  def render
    {
      name: @metric.name,
      timestamp: @metric.created_at.to_unix,
      value: render_value,
      success: @metric.success
    }
  end

  def render_value
    case @metric.metric_type
    when Metric::Type::Integer then @metric.integer_value
    when Metric::Type::Float   then @metric.float_value
    when Metric::Type::String  then @metric.string_value
    when Metric::Type::Bool    then @metric.boolean_value
    else
      -1
    end
  end
end
