class CreateOrganizations::V20201117222032 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Organization) do
      primary_key id : Int64

      add name : String
      add_timestamps
    end

    alter :domains do
      add_belongs_to organization : Organization?, on_delete: :cascade
    end
  end

  def rollback
    alter :domains do
      remove_belongs_to :organization
    end

    drop table_for(Organization)
  end
end
