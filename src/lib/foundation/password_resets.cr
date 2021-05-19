module Foundation::PasswordResets
  struct TokenData
    property user_id : String
    property expires_at : Time

    def initialize(@user_id : String, @expires_at : Time)
    end

    def initialize(@user_id : String, expires_at : String)
      @expires_at = Time.unix(expires_at.to_i64)
    end

    def self.from(token : String) : self
      parts = token.to_s.split ":"
      new parts[0], parts[1]
    end

    def self.from(token : Slice(UInt8)) : self
      from String.new(token)
    end

    def to_s(io : IO)
      io << user_id
      io << ":"
      io << expires_at.to_unix
    end
  end

  # Password reset encrypted token routines
  # inspired by Authentic
  private def self.encryptor
    Lucky::MessageEncryptor.new(secret: Foundation.settings.secret_key)
  end

  def self.generate_token(user_id : String, expires_at : Time)
    generate_token TokenData.new(user_id, expires_at)
  end

  def self.generate_token(token_data : TokenData) : String
    Foundation.settings.stubbed_token || encryptor.encrypt_and_sign token_data.to_s
  end

  def self.parse_token(token_data : String) : TokenData
    token_string = encryptor.verify_and_decrypt token_data
    TokenData.from(token_string)
  end

  def self.valid_reset_token?(token : String) : Bool
    parse_token(token).expires_at >= Time.now
  end

  def self.valid_reset_token?(token : TokenData) : Bool
    token.expires_at >= Time.utc
  end
end
