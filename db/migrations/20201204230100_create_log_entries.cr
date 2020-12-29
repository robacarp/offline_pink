class CreateLogEntries::V20201204230100 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create :log_entries do
      primary_key id : Int64

      add text : String
      add severity : Int32
      add monitor_event : Time

      add_belongs_to domain : Domain?, on_delete: :cascade

      add_timestamps
    end

    execute <<-SQL
      CREATE SEQUENCE log_entry_run_sequence
      AS BIGINT
      OWNED BY log_entries.monitor_event
    SQL
  end

  def rollback
    drop :log_entries
  end
end
