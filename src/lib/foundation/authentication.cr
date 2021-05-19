module Foundation::Authentication
  def self.encrypt_password(raw_password : String) : String
    Crypto::Bcrypt::Password.create(
      raw_password,
      cost: Foundation.settings.encryption_cost
    ).to_s
  end

  def self.correct_password?(password_attempt : String, encrypted_password : String) : Bool
    Crypto::Bcrypt::Password.new(encrypted_password).verify(password_attempt)
  end
end
