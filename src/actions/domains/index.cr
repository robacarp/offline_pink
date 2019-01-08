class Domains::Index < BrowserAction
  require_logged_in!

  get "/my/domains" do
    render IndexPage, domains: current_user.domains
  end
end
