class CreateLogEntries::V20201204230100 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(LogEntry) do
      primary_key id : Int64

      add text : String
      add severity : Int32
      add monitor_event : Int64

      add_belongs_to domain : Domain?, on_delete: :cascade
      add_belongs_to icmp_monitor : Monitor::Icmp?, on_delete: :cascade, references: "icmp_monitors"
      add_belongs_to http_monitor : Monitor::Http?, on_delete: :cascade, references: "http_monitors"

      add_timestamps
    end

    execute <<-SQL
      CREATE SEQUENCE log_entry_run_sequence
      AS BIGINT
      OWNED BY log_entries.monitor_event
    SQL
  end

  def rollback
    drop table_for(LogEntry)
  end
end
