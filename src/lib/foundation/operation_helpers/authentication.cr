require "crypto/bcrypt"

module Foundation::OperationHelpers::Authentication
  # Inspired by Authentic
  delegate encryption_cost, to: Foundation.settings

  def encrypt_password(
    from password_field : Avram::Attribute | Avram::PermittedAttribute,
    to encrypted_password_field : Avram::Attribute | Avram::PermittedAttribute
  ) : Void
    password_field.value.try do |raw_password|
      encrypted_password_field.value = Crypto::Bcrypt::Password.create(
        raw_password,
        cost: encryption_cost
      ).to_s
    end
  end
end
