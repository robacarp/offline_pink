class Home::Index < BrowserAction
  include Auth::SkipRequireSignIn

  unexpose current_user

  get "/" do
    render HomePage
  end
end
