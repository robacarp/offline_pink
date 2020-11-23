class Me::Show < BrowserAction
  include Sift::DontEnforceAuthorization

  get "/my/account" do
    html ShowPage, user: current_user
  end
end
