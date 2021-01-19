class SignUps::New < BrowserAction
  include Auth::RedirectSignedInUsers
  include Sift::DontEnforceAuthorization

  get "/sign_up" do
    html NewPage, operation: SignUpUser.new
  end
end
