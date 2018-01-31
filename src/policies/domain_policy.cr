class DomainPolicy < ApplicationPolicy
  policy_for Domain,
    new: :logged_in,
    create: :user_is_owner,
    show: :user_is_owner,
    delete: :user_is_owner,
    destroy: :user_is_owner,
    revalidate: :user_is_owner

  resolve do
    Domain.all("WHERE user_id = ?", current_user.id)
  end
end
