class My::Account::Show < BrowserAction
  get "/my/account" do
    html ShowPage, user: current_user, save: SaveUser.new(current_user)
  end
end
