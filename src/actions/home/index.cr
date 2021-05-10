class Home::Index < BrowserAction
  allow_guests

  get "/" do
    html HomePage
  end
end
