class SaveOrganization < Organization::SaveOperation
  include Sift::AuthorizedOperation

  permit_columns name

  needs user : User

  before_save do
    validate_required name
  end

  after_save create_default_membership

  def create_default_membership(organization : Organization)
    SaveMembership.create!(
      user: user,
      organization: organization,
      is_admin: true,
      pending: false
    )
  end
end
