class PasswordResets::Create < BrowserAction
  include Foundation::ActionHelpers::PasswordReset(User, UserQuery)

  redirect_without_reset_token

  post "/password_resets" do
    user = password_reset_token_user
    User::ResetPassword.update(user, params) do |operation, user|
      if operation.saved?
        destroy_password_reset_token
        sign_in user
        flash.success = "Your password has been reset"
        redirect to: Home::Index
      else
        html NewPage, operation: operation
      end
    end
  end
end
