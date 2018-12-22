class AccountForm < User::BaseForm
  fillable email
  virtual password : String
  virtual new_password : String

  def prepare
    validate_required email

    record.try do |user|
      unless user.valid_password? password.value
        password.add_error "is incorrect"
        return
      end

      unless new_password.value.blank?
        validate_size_of new_password, min: 12, max: 72
        return if new_password.errors.any?
        crypted_password.value = User.hash_password new_password.value.not_nil!
      end
    end
  end
end
