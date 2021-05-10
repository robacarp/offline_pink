require "./password_validations"

class User::ResetPassword < User::SaveOperation
  include PasswordValidations
  include Foundation::OperationHelpers::Authentication

  attribute password : String
  attribute password_confirmation : String

  before_save do
    encrypt_password from: password, to: encrypted_password
  end
end
