class Registration::New < BrowserAction
  include Auth::RedirectIfSignedIn

  get "/register" do
    render NewPage, form: RegistrationForm.new
  end
end
