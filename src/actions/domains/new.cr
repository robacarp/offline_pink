class Domains::New < BrowserAction
  require_logged_in!

  route do
    render NewPage, form: DomainForm.new(user: current_user)
  end
end
