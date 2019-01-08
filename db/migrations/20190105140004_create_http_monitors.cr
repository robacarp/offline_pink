class CreateHTTPMonitors::V20190105140004 < LuckyRecord::Migrator::Migration::V1
  def migrate
    create :http_monitors do
      add_belongs_to domain : Domain, on_delete: :cascade
      add ssl : Bool, default: true
      add path : String
      add expected_status_code : Int32, default: 200
      add expected_content : String?, default: nil
    end
  end

  def rollback
    drop :http_monitors
  end
end
