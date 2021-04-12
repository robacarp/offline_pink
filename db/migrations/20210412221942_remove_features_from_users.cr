class RemoveFeaturesFromUsers::V20210412221942 < Avram::Migrator::Migration::V1
  def migrate
    alter :users do
      remove :features
    end
  end

  def rollback
    alter :users do
      add features : Int32, default: 0
    end
  end
end
