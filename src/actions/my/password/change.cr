class My::Password::Change < BrowserAction
  get "/my/password" do
    html ShowPage, user: current_user, save: User::ChangePassword.new(current_user)
  end
end
