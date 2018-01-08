class DomainPolicy < ApplicationPolicy
  default_policy_for Domain

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
end
