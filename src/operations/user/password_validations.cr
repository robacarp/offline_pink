module PasswordValidations
  private def run_password_validations
    validate_required password, password_confirmation
    validate_confirmation_of password, with: password_confirmation

    # max size of 72 because that's the max size of bcrypts input
    validate_size_of password, min: 6, max: 72
  end
end
