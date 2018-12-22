class RegistrationForm < User::BaseForm
  fillable email
  virtual password : String

  def prepare
    features.value = 0

    validate_uniqueness_of email
    validate_required password
    validate_size_of password, min: 12, max: 72

    password.value.try do |value|
      crypted_password.value = User.hash_password value
    end
  end
end
