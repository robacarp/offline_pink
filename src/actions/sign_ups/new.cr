class SignUps::New < BrowserAction
  include Auth::RedirectIfSignedIn

  get "/register" do
    render NewPage, form: SignUpForm.new
  end
end
