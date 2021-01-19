class CreateRegions::V20201109235324 < Avram::Migrator::Migration::V1
  def migrate
    create :regions do
      primary_key id : Int64
      add name : String, unique: true
      add_timestamps
    end
  end

  def rollback
    drop :regions
  end
end
