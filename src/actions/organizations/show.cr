class Organizations::Show < BrowserAction
  authorized_lookup Organization do |query|
    query
      .preload_memberships(MembershipQuery.new.preload_user)
      .preload_domains
  end

  get "/organization/:id" do
    html ShowPage, organization: organization
  end
end
