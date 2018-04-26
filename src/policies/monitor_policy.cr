class MonitorPolicy < ApplicationPolicy
  policy_for Monitor,
    new:     :user_owns_related_domain,
    create:  :user_owns_related_domain,
    show:    :user_owns_related_domain,
    delete:  :user_owns_related_domain,
    destroy: :user_owns_related_domain
end
