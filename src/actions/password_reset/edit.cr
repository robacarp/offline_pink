class PasswordResets::Edit < BrowserAction
  allow_guests

  get "/password-reset/edit" do
    html NewPage, operation: User::ResetPassword.new
  end
end
