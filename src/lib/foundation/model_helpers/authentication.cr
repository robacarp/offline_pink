module Foundation::ModelHelpers::Authentication
  def correct_password?(password_attempt : String) : Bool
    Crypto::Bcrypt::Password.new(encrypted_password).verify(password_attempt)
  end
end
