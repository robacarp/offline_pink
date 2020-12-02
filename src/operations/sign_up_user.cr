class SignUpUser < User::SaveOperation
  include PasswordValidations

  param_key :user
  # Change password validations in src/operations/mixins/password_validations.cr

  permit_columns email
  attribute password : String
  attribute password_confirmation : String

  before_save do
    run_password_validations
    validate_uniqueness_of email
    Authentic.copy_and_encrypt password, to: encrypted_password
  end
end
