class Home::Index < BrowserAction
  include Auth::SkipRequireSignIn

  get "/" do
    render HomePage
  end
end
