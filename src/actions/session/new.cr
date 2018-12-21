class Session::New < BrowserAction
  redirect_if_signed_in!

  get "/session/new" do
    render NewPage, form: SessionForm.new
  end
end
