class SignIns::New < BrowserAction
  include Auth::RedirectIfSignedIn

  get "/session/new" do
    render NewPage, form: SignInForm.new
  end
end
