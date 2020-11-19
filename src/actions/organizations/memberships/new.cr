class Organizations::Memberships::New < BrowserAction
  get "/organization/:id/invite" do
    organization = OrganizationQuery.new
      .where_memberships(::MembershipQuery.new.user_id(current_user.id))
      .find(id)

    html Organizations::Memberships::NewPage, organization: organization, save: SaveInvite.new(organization)
  end
end
