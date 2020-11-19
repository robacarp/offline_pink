class SaveMembership < Membership::SaveOperation
  needs organization : Organization
  needs user : User

  needs is_admin : Bool = false

  before_save do
    user_id.value = user.id
    organization_id.value = organization.id
    admin.value = is_admin
  end
end
