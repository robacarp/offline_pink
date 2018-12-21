class Registration::Create < BrowserAction
  dont_require_logged_in!

  route do
    RegistrationForm.create(params) do |form, user|
      if user
        flash.info = "Thanks for signing up"
        create_session for: user
        redirect to: Home::Index
      else
        flash.info = "Couldn't create user"
        render NewPage, form: form
      end
    end
  end
end
