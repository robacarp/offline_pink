module Foundation::ActionHelpers::PasswordReset(Model, ModelQuery)
  include PasswordResets

  #
  # Utility functions for storing the password reset token
  # in the session after it's been clicked on.
  #

  # :nodoc:
  PASSWORD_RESET_TOKEN_KEY = :password_reset_token

  # Save the token in the session
  def save_password_reset_token(value)
    session.set PASSWORD_RESET_TOKEN_KEY, token
  end

  # Remove the token from the session
  def destroy_password_reset_token
    session.delete PASSWORD_RESET_TOKEN_KEY
  end

  # Read the token from the session
  def retrieve_password_reset_token : TokenData
    token_text = session.get?(PASSWORD_RESET_TOKEN_KEY)
    unless token_text
      raise "No password reset in process"
    end
    PasswordResets.parse_token(token_text)
  end

  def generate_password_reset_token(user : Model, expires_in : Time::Span = 1.hour) : String
    PasswordResets.generate_token(
      TokenData.new(user.id.to_s, expires_in.from_now)
    )
  end

  def password_reset_token_user : Model
    ModelQuery.new.find retrieve_password_reset_token.user_id
  end

  macro redirect_without_reset_token
    before require_password_reset_token
  end

  # Password reset encrypted token routines
  # inspired by Authentic
  def require_password_reset_token
    token = retrieve_password_reset_token
    if PasswordResets.valid_reset_token?(token)
      continue
    else
      flash.failure = "The password reset link is incorrect or expired. Please try again."
      redirect to: "/"
    end
  end
end
