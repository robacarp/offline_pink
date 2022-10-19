class AddSubscriptions::V20221017190616 < Avram::Migrator::Migration::V1
  def migrate
    create :subscriptions do
      primary_key id : Int64

      add stripe_id : String, index: true, unique: true
      add expires_at : Time, default: Time::UNIX_EPOCH

      add_belongs_to user : User, on_delete: :restrict, unique: true

      add_timestamps
    end

    alter :users do
      add stripe_id : String?, index: true, unique: true
    end
  end

  def rollback
    drop :subscriptions

    alter :users do
      remove :stripe_id
    end
  end
end
