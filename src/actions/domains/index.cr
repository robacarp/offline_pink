class Domains::Index < BrowserAction
  get "/my/domains" do
    html IndexPage, domains: current_user.domains
  end
end
