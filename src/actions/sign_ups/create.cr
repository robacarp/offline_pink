class SignUps::Create < BrowserAction
  include Auth::RedirectSignedInUsers
  include Sift::DontEnforceAuthorization

  post "/sign_up" do
    SignUpUser.create(params) do |operation, user|
      if user
        flash.info = "Account created"
        sign_in(user)
        redirect to: Home::Index
      else
        flash.info = "Couldn't create account"
        html NewPage, operation: operation
      end
    end
  end
end
