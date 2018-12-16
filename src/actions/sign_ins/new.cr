class Session::New < BrowserAction
  include Auth::RedirectIfSignedIn

  get "/session/new" do
    render NewPage, form: SessionForm.new
  end
end
