class SignUpUser < User::SaveOperation
  include PasswordValidations
  include Foundation::OperationHelpers::Authentication

  param_key :user
  # Change password validations in src/operations/mixins/password_validations.cr

  permit_columns email
  attribute password : String
  attribute password_confirmation : String

  before_save do
    validate_uniqueness_of email
    run_password_validations
    encrypt_password from: password, to: encrypted_password
  end
end
