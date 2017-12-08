class RoutePolicy < ApplicationPolicy
  default_policy_for Route

  def new?
    logged_in?
  end

  def create?
    object.domain.user_id == current_user.id
  end
end
