class PushoverKeyPolicy < ApplicationPolicy
  policy_for PushoverKey,
    :link_verify,
    edit:   :user_is_owner,
    update: :user_is_owner,
    verify: :user_is_owner

  def link_verify?
    true
  end
end
