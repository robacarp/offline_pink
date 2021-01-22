class AddPushoverUserKeyToUsers::V20210108224006 < Avram::Migrator::Migration::V1
  def migrate
    alter :users do
      add pushover_key : String?
      add pushover_device : String?
      add valid_pushover_settings : Int32 = 1024, default: 1024
      add email_valid : Int32 = 1024, default: 1024
    end
  end

  def rollback
    alter :users do
      remove :pushover_key
      remove :pushover_device
      remove :valid_pushover_settings
      remove :email_valid
    end
  end
end
