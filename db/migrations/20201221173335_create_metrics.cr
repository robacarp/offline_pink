class CreateMetrics::V20201221173335 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create :metrics do
      primary_key id : Int64
      add_belongs_to monitor : Monitor, on_delete: :cascade

      add name : String
      add success : Bool

      add metric_type : Int32
      add boolean_value : Bool?
      add integer_value : Int32?
      add float_value : Float64?
      add string_value : String?
      add units : String?

      add monitor_event : Time

      add_timestamps
    end
  end

  def rollback
    drop :metrics
  end
end
