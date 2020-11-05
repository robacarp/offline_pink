class CreateDomains::V20181223212848 < Avram::Migrator::Migration::V1
  def migrate
    create :domains do
      primary_key id : Int64
      add name : String, unique: true
      add_belongs_to user : User, on_delete: :cascade
      add is_valid : Bool, default: true
      add status_code : Int32, default: -1
      add_timestamps
    end
  end

  def rollback
    drop :domains
  end
end
