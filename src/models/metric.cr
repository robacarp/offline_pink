class Metric < BaseModel
  enum Type
    None = 0
    Integer = 1
    Float = 2
    String = 3
    Bool = 4
  end

  table do
    belongs_to monitor : Monitor
    column metric_type : Metric::Type

    column name : String
    column success : Bool = false

    column boolean_value : Bool?
    column integer_value : Int32?
    column float_value : Float64?
    column string_value : String?
    column units : String?

    column monitor_event : Time
    column host : String?
  end

  def string_value
    case metric_type
    when Metric::Type::Integer then integer_value
    when Metric::Type::Float   then float_value
    when Metric::Type::String  then string_value
    when Metric::Type::Bool    then boolean_value
    else
      -1
    end.to_s
  end
end
