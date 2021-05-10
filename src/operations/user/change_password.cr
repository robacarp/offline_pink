require "./password_validations"

class User::ChangePassword < User::SaveOperation
  include Foundation::OperationHelpers::Authentication
  include PasswordValidations

  attribute old_password : String
  attribute password : String
  attribute password_confirmation : String

  before_save check_old_password
  before_save run_password_validations

  before_save do
    encrypt_password from: password, to: encrypted_password
  end

  def check_old_password
    return unless user = record
    unless user.correct_password? old_password.value.to_s
      old_password.add_error "incorrect"
    end
  end
end
