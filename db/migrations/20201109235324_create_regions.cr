class CreateRegions::V20201109235324 < Avram::Migrator::Migration::V1
  def migrate
    create :regions do
      primary_key id : Int64
      add name : String, unique: true
      add_timestamps
    end

    alter :icmp_monitors do
      add_belongs_to region : Region, on_delete: :restrict
    end

    alter :http_monitors do
      add_belongs_to region : Region, on_delete: :restrict
    end
  end

  def rollback
    alter :icmp_monitors do
      remove_belongs_to :region
    end

    alter :http_monitors do
      remove_belongs_to :region
    end

    drop :regions
  end
end
