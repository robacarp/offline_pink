class PasswordResets::Edit < BrowserAction
  get "/password_resets/edit" do
    html NewPage, operation: User::ResetPassword.new
  end
end
