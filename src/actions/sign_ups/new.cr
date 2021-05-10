class SignUps::New < BrowserAction
  redirect_signed_in_users

  get "/sign_up" do
    html NewPage, operation: SignUpUser.new
  end
end
