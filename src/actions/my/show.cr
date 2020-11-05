class Me::Show < BrowserAction
  get "/my/account" do
    html ShowPage, user: current_user
  end
end
