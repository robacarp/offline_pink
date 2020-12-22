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
    when Metric.integer then @metric.integer_value
    when Metric.float   then @metric.float_value
    when Metric.string  then @metric.string_value
    when Metric.bool    then @metric.boolean_value
    else
      -1
    end
  end
end
