class Domains::Index < BrowserAction
  get "/my/domains" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, domains: domains
  end
end
