class User::InvitesPolicy < ApplicationPolicy
  policy_for User,
    edit: :user_is_object,
    update: :user_is_object

  def user_is_object?
    object == current_user
  end
end
