class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    html HomePage
  end
end
