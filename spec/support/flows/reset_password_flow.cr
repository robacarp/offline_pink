class ResetPasswordFlow < BaseFlow
  private getter user, authentication_flow, token : String
  delegate sign_in, sign_out, should_have_password_error, should_be_signed_in,
    to: authentication_flow

  def initialize(@user : User)
    @authentication_flow = AuthenticationFlow.new(user.email)
    @token = Foundation::PasswordResets.generate_token(user.id.to_s, 1.hour.from_now)
  end

  def request_password_reset
    with_token do
      visit PasswordResetRequests::New
      fill_form User::RequestPasswordReset, email: user.email
      click "@request-password-reset-button"
    end

    PasswordResetRequestEmail.new(user, token).should be_delivered
  end

  def should_have_sent_reset_email
  end

  def reset_password(password)
    visit PasswordResets::New.with(token)
    fill_form User::ResetPassword,
      password: password,
      password_confirmation: password
    click "@update-password-button"
  end

  private def with_token
    Foundation.temp_config(stubbed_token: token) do
      yield
    end
  end
end
