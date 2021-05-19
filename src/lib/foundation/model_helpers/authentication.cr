module Foundation::ModelHelpers::Authentication
  def correct_password?(password_attempt : String) : Bool
    Foundation::Authentication.correct_password?(password_attempt, encrypted_password)
  end
end
