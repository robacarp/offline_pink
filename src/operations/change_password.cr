class ChangePassword < User::SaveOperation
  include PasswordValidations

  attribute old_password : String
  attribute password : String
  attribute password_confirmation : String

  before_save check_old_password
  before_save run_password_validations

  before_save do
    Authentic.copy_and_encrypt password, to: encrypted_password
  end

  def check_old_password
    return unless user = record
    unless Authentic.correct_password?(user, old_password.value.to_s)
      old_password.add_error "incorrect"
    end
  end
end
