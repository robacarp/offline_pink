class CreateMonitors::V20201216181913 < Avram::Migrator::Migration::V1
  def migrate
    create :monitors do
      primary_key id : Int64
      add_belongs_to domain : Domain, on_delete: :cascade
      add_belongs_to region : Region, on_delete: :cascade

      add monitor_type : Int32
      add config : JSON::Any

      add_timestamps
    end


    alter :log_entries do
      add_belongs_to monitor : Monitor?, on_delete: :cascade
    end
  end

  def rollback
    alter :log_entries do
      remove_belongs_to :monitor
    end

    drop :monitors
  end
end
