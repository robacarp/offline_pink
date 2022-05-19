class RequestPasswordReset::New < BrowserAction
  redirect_signed_in_users

  get "/forgot-password" do
    html NewPage, operation: User::RequestPasswordReset.new
  end
end
