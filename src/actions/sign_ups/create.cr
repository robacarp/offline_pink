class Registration::Create < BrowserAction
  include Auth::RedirectIfSignedIn

  route do
    RegistrationForm.create(params) do |form, user|
      if user
        flash.info = "Thanks for signing up"
        sign_in(user)
        redirect to: Home::Index
      else
        flash.info = "Couldn't sign you up"
        render NewPage, form: form
      end
    end
  end
end
