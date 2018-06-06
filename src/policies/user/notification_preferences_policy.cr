class User::NotificationPreferencesPolicy < ApplicationPolicy
  policy_for User,
    edit:   :user_is_self,
    update: :user_is_self

  def user_is_self?
    object == current_user
  end
end
