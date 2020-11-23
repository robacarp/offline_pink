class DomainPolicy < Domain::BasePolicy
  class Scope < Domain::BaseScope
    def scoped_query
      PolymorphicDomainOwnershipQuery.run(user.id)
    end
  end
end
