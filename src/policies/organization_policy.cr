class OrganizationPolicy < ApplicationPolicy(Organization)
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
end
