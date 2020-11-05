class CreateMonitors::V20190103205415 < Avram::Migrator::Migration::V1
  def migrate
    create :icmp_monitors do
      primary_key id : Int64
      add_belongs_to domain : Domain, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop :icmp_monitors
  end
end
