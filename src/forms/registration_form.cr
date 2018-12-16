class RegistrationForm < User::BaseForm
  fillable email
  virtual password : String

  def prepare
    validate_uniqueness_of email
    validate_required password
    validate_size_of password, min: 12

    password.value.try do |value|
      crypted_password = User.hash_password value
    end
  end
end
