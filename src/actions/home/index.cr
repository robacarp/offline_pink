class Home::Index < BrowserAction
  include Auth::AllowGuests
  include Sift::DontEnforceAuthorization

  get "/" do
    html HomePage
  end
end
