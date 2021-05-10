class PasswordResetRequests::New < BrowserAction
  redirect_signed_in_users

  route do
    html NewPage, operation: User::RequestPasswordReset.new
  end
end
