class Organizations::Show < BrowserAction
  get "/organization/:id" do
    organization = OrganizationQuery.new
      .where_memberships(MembershipQuery.new.user_id(current_user.id))
      .preload_memberships(MembershipQuery.new.preload_user)
      .find(id)

    html ShowPage, organization: organization
  end
end
