class HostPolicy < ApplicationPolicy
  policy_for Host, show: :user_owns_related_domain
end
