class CreateUsers::V20181214214853 < LuckyRecord::Migrator::Migration::V1
  def migrate
    create :users do
      add email : String
      add crypted_password : String

      add invite_id : Int32?
      add features : Int32, default: 0
    end
  end

  def rollback
    drop :users
  end
end
