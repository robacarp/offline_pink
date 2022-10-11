class AddDomainVerificationField::V20221007223200 < Avram::Migrator::Migration::V1
  def migrate
    alter :domains do
      add verification_token : String, default: ""
      add verification_status : Int32, default: -1
      add verified_at : Time, default: Time::UNIX_EPOCH
    end
  end

  def rollback
    alter :domains do
      remove :verification_token
      remove :verification_status
      remove :verified_at
    end
  end
end
