class PolymorphicDomainOwnershipQuery
  def self.run(user_id : Number) : DomainQuery
    sql = <<-SQL
      select domains.id
      from domains
      left join organizations on organizations.id = domains.organization_id
      left join memberships on organizations.id = memberships.organization_id
      where
         domains.user_id = $1
      or memberships.user_id = $1
    SQL

    results = AppDatabase.run do |db|
      db.query_all sql, user_id, as: { id: Int64 }
    end

    ids = results.map &.dig(:id)
    DomainQuery.new.id.in(ids)
  end
end

class DomainPolicy < Domain::BasePolicy
  class Scope < Domain::BaseScope
    def scoped_query
      PolymorphicDomainOwnershipQuery.run(user.id)
    end
  end
end
