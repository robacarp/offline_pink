class OrganizationPolicy < Organization::BasePolicy
  def member_of_org
    Scope.new(user, OrganizationQuery.new).scoped_query.first?
  end

  def user_is_owner
    false
  end

  def read?
    member_of_org
  end

  class Scope < Organization::BaseScope
    def scoped_query
      OrganizationQuery.new
        .where_memberships(MembershipQuery.new.user_id(user.id))
    end
  end
end
