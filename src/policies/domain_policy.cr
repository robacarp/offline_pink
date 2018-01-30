class DomainPolicy < ApplicationPolicy
  policy_for Domain,
    new: :user_is_owner,
    create: :user_is_owner,
    show: :user_is_owner,
    delete: :user_is_owner,
    destroy: :user_is_owner,
    revalidate: :user_is_owner

  resolve do
    Domain.all("WHERE user_id = ?", current_user.id)
  end

  def new?
    logged_in?
  end

  def create?
    user_is_owner?
  end

  def show?
    user_is_owner?
  end

  def delete?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  def revalidate?
    create?
  end
end
