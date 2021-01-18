class AddPushoverUserKeyToUsers::V20210108224006 < Avram::Migrator::Migration::V1
  def migrate
    alter :users do
      add pushover_key : String?
      add pushover_key_valid : Bool = false, default: false
      add email_valid : Bool = false, default: false
    end
  end

  def rollback
    alter :users do
      remove :pushover_key
      remove :pushover_key_valid
      remove :email_valid
    end
  end
end
