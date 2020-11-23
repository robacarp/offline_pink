class Domains::Index < BrowserAction
  get "/my/domains" do
    domains = authorized_scope_for Domain
    html IndexPage, domains: domains
  end
end
