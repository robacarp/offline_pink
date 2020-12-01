class DomainPolicy < Domain::BasePolicy
  def user_is_owner_or_member_of_organization_owner?
    return true if object.user_id == user.id
    PolymorphicDomainOwnershipQuery
      .run(user)
      .map(&.id)
      .includes?(object.id)
  end

  def update?
    user_is_owner_or_member_of_organization_owner?
  end

  def read?
    user_is_owner_or_member_of_organization_owner?
  end

  class Scope < Domain::BaseScope
    def scoped_query
      PolymorphicDomainOwnershipQuery.run(user)
    end
  end

  class Create < Domain::BaseCreator
    def authorize
      true
    end
  end
end
