class SaveInvite < Membership::SaveOperation
  needs organization : Organization
  attribute email : String

  before_save do
    organization_id = organization.id
    validate_required email
  end

  before_save lookup_user

  def lookup_user
    return unless provided_email = email.value

    user = UserQuery.new.email(provided_email).first?

    unless user
      email.add_error "is not on any user account"
      return
    end

    membership = MembershipQuery.new
      .user_id(user.id)
      .organization_id(organization.id)

    if ! membership.first?
      user_id.value = user.id
    else
      email.add_error "is already a member of #{organization.name}"
    end
  end
end
