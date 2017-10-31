class CheckPolicy < ApplicationPolicy
  default_policy_for Check

  resolve do
    Check.all("WHERE user_id = ?", current_user.id)
  end

  def show?
    user_is_owner?
  end

  def new?
    logged_in?
  end

  def create?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end
end
