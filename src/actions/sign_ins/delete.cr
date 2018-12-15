class SignIns::Delete < BrowserAction
  delete "/session" do
    sign_out
    flash.info = "You have been signed out"
    redirect to: SignIns::New
  end
end
