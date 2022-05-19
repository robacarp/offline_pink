class PasswordResets::New < BrowserAction
  include Foundation::ActionHelpers::PasswordReset(User, UserQuery)

  redirect_signed_in_users

  param token : String

  get "/password-reset" do
    save_password_reset_token token
    redirect to: PasswordReset::Edit
  end
end
