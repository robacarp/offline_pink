class Domains::New < BrowserAction
  require_logged_in!

  get "/my/domains/new" do
    render NewPage, form: DomainForm.new(user: current_user)
  end
end
