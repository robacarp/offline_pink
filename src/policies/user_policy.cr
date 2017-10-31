class UserPolicy < ApplicationPolicy
  policy_for User, :new, :create,
    show: :user_is_self,
    edit: :user_is_self,
    update: :user_is_self

  def user_is_self?
    object.id == current_user
  end

  def new?
    ! logged_in?
  end

  def create?
    ! logged_in?
  end
end
