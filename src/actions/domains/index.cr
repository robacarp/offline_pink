class Domains::Index < BrowserAction
  require_logged_in!

  route do
    render IndexPage, domains: current_user.domains
  end
end
