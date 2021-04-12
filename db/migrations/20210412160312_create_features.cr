class CreateFeatures::V20210412160312 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create :features do
      primary_key id : Int64
      add name : String, unique: true
      add state : Int32, default: 1 # disabled
      add editable : Bool, default: true
      add_timestamps
    end

    create :enabled_features do
      primary_key id : Int64

      add_belongs_to user : User, on_delete: :cascade
      add_belongs_to feature : Feature, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop :enabled_features
    drop :features
  end
end
