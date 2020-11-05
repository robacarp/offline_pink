class CreateUsers::V20181214214853 < Avram::Migrator::Migration::V1
  def migrate
    create :users do
      primary_key id : Int64
      add email : String
      add encrypted_password : String

      add invite_id : Int32?
      add features : Int32, default: 0
      add_timestamps
    end
  end

  def rollback
    drop :users
  end
end
