module Foundation::ActionHelpers::PasswordReset(Model, ModelQuery)
  struct TokenData
    property user_id : String
    property expires_at : String

    def initialize(@user_id : String, @expires_at : String)
    end

    def self.from(token : String) : self
      parts = token.to_s.split ":"
      new parts[0], parts[1]
    end
  end

  delegate secret_key, stubbed_token, to: Foundation.settings

  PASSWORD_RESET_TOKEN_KEY = :password_reset_token

  def save_password_reset_token(value)
    session.set(PASSWORD_RESET_TOKEN_KEY, token)
  end

  def retrieve_password_reset_token : String
    session.get?(PASSWORD_RESET_TOKEN_KEY) || raise "No password reset in process"
  end

  def parsed_token : TokenData
    TokenData.from(retrieve_password_reset_token)
  end

  def destroy_password_reset_token
    session.delete PASSWORD_RESET_TOKEN_KEY
  end

  def password_reset_token_user : Model
    ModelQuery.new.find parsed_token.user_id
  end

  macro redirect_without_reset_token
    before require_password_reset_token
  end

  # Password reset encrypted token routines
  # inspired by Authentic
  def require_password_reset_token
    token = retrieve_password_reset_token
    if valid_reset_token?(token)
      continue
    else
      flash.failure = "The password reset link is incorrect or expired. Please try again."
      redirect to: "/"
    end
  end

  def encryptor
    Lucky::MessageEncryptor.new(secret: secret_key)
  end

  def generate_password_reset_token(user : Model, expires_in : Time::Span = 1.hour) : String
    stubbed_token || encryptor.encrypt_and_sign "#{user.id}:#{expires_in.from_now.to_unix_ms}"
  end

  def valid_reset_token?(token : String) : Bool
    expiration_in_ms = encryptor.verify_and_decrypt(token).to_s.split(":").last
    Time.utc.to_unix_ms <= expiration_in_ms.to_i64
  end
end
