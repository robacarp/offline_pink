class SignIns::New < BrowserAction
  include Auth::RedirectSignedInUsers
  include Sift::DontEnforceAuthorization

  get "/sign_in" do
    html NewPage, operation: SignInUser.new
  end
end
