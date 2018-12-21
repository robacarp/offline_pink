class Session::Delete < BrowserAction
  delete "/session" do
    destroy_session
    flash.info = "You have been signed out"
    redirect to: Session::New
  end
end
