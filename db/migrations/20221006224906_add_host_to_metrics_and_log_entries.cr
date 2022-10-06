class AddHostToMetricsAndLogEntries::V20221006224906 < Avram::Migrator::Migration::V1
  def migrate
    alter :metrics do
      add host : String?
    end

    alter :log_entries do
      add host : String?
    end
  end

  def rollback
    alter :metrics do
      remove :host
    end

    alter :log_entries do
      remove :host
    end
  end
end
