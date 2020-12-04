class OrganizationPolicy < Organization::BasePolicy
  def member_of_org
    if Scope.new(user, OrganizationQuery.new).scoped_query.first?
      true
    else
      false
    end
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

  class Create < Organization::BaseCreator
    def authorize
      # todo
      true
    end
  end
end
