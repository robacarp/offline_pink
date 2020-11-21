class CreateHTTPMonitors::V20190105140004 < Avram::Migrator::Migration::V1
  def migrate
    create :http_monitors do
      primary_key id : Int64
      add_belongs_to domain : Domain, on_delete: :cascade
      add ssl : Bool, default: true
      add path : String, default: "/"
      add expected_status_code : Int32, default: 200
      add expected_content : String?, default: nil
      add_timestamps
    end
  end

  def rollback
    drop :http_monitors
  end
end
