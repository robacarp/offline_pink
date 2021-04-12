class Organizations::Show < BrowserAction
  get "/organization/:id" do
    organization = OrganizationQuery.new
      .preload_memberships(MembershipQuery.new.preload_user)
      .preload_domains
      .find(id)

    html ShowPage, organization: organization
  end
end
