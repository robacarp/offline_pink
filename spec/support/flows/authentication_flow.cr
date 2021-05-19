class AuthenticationFlow < BaseFlow
  private getter email

  def initialize(@email : String)
  end

  def sign_up(password)
    visit SignUps::New
    fill_form SignUpUser,
      email: email,
      password: password,
      password_confirmation: password
    click "@sign-up-button"
  end

  def sign_out
    should_be_signed_in
    visit My::Account::Show
    el("a", text: "Sign out").click
  end

  def sign_in(password)
    visit SignIns::New
    fill_form SignInUser,
      email: email,
      password: password
    click "@sign-in-button"
  end

  def should_be_signed_in
    sign_in_button.should_not be_on_page
  end

  def should_have_password_error
    el("body", text: "Password is wrong").should be_on_page
  end

  private def sign_in_button
    el("a", text: "Sign In")
  end
end
