class SignIns::New < BrowserAction
  redirect_signed_in_users

  get "/sign_in" do
    html NewPage, operation: SignInUser.new
  end
end
