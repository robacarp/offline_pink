class DomainPolicy < ApplicationPolicy(Domain)
  def user_is_owner_or_member_of_organization_owner?
    return false unless user_id = record.user_id
    return true if record.user_id == user.id
    PolymorphicDomainOwnershipQuery
      .run(user)
      .map(&.id)
      .includes?(record.id)
  end

  def show?
    user_is_owner_or_member_of_organization_owner?
  end

  def update?
    user_is_owner_or_member_of_organization_owner?
  end

  def read?
    user_is_owner_or_member_of_organization_owner?
  end

  def delete?
    user_is_owner_or_member_of_organization_owner?
  end
end
