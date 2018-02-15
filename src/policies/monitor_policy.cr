class MonitorPolicy < ApplicationPolicy
  policy_for Monitor,
    new: :user_owns_domain,
    create: :new,
    show: :user_owns_domain,
    delete: :user_owns_domain,
    destroy: :user_owns_domain

  def user_owns_domain?
    return unless domain_id = object.domain_id
    return unless domain = Domain.find(domain_id)
    domain.user_id == current_user.id
  end
end
