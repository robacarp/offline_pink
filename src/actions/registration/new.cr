class Registration::New < BrowserAction
  dont_require_logged_in!

  get "/register" do
    render NewPage, form: RegistrationForm.new
  end
end
