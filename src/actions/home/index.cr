class Home::Index < BrowserAction
  dont_require_logged_in!

  get "/" do
    render HomePage
  end
end
