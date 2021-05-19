require "crypto/bcrypt"

module Foundation::OperationHelpers::Authentication
  # Inspired by Authentic
  def encrypt_password(
    from password_field : Avram::Attribute | Avram::PermittedAttribute,
    to encrypted_password_field : Avram::Attribute | Avram::PermittedAttribute
  ) : Void
    password_field.value.try do |raw_password|
      encrypted_password_field.value = Foundation::Authentication.encrypt_password(raw_password)
    end
  end
end
