class CreateMonitors::V20190103205415 < LuckyRecord::Migrator::Migration::V1
  def migrate
    create :icmp_monitors do
      add_belongs_to domain : Domain, on_delete: :cascade
    end
  end

  def rollback
    drop :icmp_monitors
  end
end
