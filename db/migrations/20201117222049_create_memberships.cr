class CreateMemberships::V20201117222049 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Membership) do
      primary_key id : Int64
      add_belongs_to user : User, on_delete: :cascade
      add_belongs_to organization : Organization, on_delete: :cascade

      add pending : Bool, default: true
      add admin : Bool, default: false

      add_timestamps
    end
  end

  def rollback
    drop table_for(Membership)
  end
end
