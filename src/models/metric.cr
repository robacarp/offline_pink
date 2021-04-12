class Metric < BaseModel
  avram_enum Type do
    None = 0
    Integer = 1
    Float = 2
    String = 3
    Bool = 4
  end

  table do
    belongs_to monitor : Monitor
    column metric_type : Int32

    column name : String
    column success : Bool = false

    column boolean_value : Bool?
    column integer_value : Int32?
    column float_value : Float64?
    column string_value : String?
    column units : String?

    column monitor_event : Time
  end
end
