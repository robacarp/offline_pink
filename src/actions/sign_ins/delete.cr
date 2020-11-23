class SignIns::Delete < BrowserAction
  include Sift::DontEnforceAuthorization

  delete "/sign_out" do
    sign_out
    flash.info = "You have been signed out"
    redirect to: SignIns::New
  end
end
