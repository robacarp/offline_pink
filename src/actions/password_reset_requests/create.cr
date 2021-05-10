class PasswordResetRequests::Create < BrowserAction
  include Foundation::ActionHelpers::PasswordReset(User, UserQuery)

  redirect_signed_in_users

  route do
    User::RequestPasswordReset.run(params) do |operation, user|
      if user
        token = generate_password_reset_token(user)
        PasswordResetRequestEmail.new(user, token).deliver_later
        flash.success = "You should receive an email on how to reset your password shortly"
        redirect SignIns::New
      else
        html NewPage, operation: operation
      end
    end
  end
end
