class RoutePolicy < ApplicationPolicy
  default_policy_for Route

  def new?
    logged_in?
  end

  def user_owns_domain?
    object.domain.user_id == current_user.id
  end

  def create?
    user_owns_domain?
  end

  def show?
    user_owns_domain?
  end

  def destroy?
    user_owns_domain?
  end

  def delete?
    user_owns_domain?
  end
end
