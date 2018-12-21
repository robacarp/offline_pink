class SessionForm < LuckyRecord::VirtualForm
  virtual email : String
  virtual password : String

  def submit
    validate_required email
    validate_required password

    unless valid?
      return yield self, nil
    end

    user = email.value.try do |value|
      UserQuery.new.email(value).first?
    end

    unless user
      return yield self, nil
    end

    if user.valid_password? password.value.to_s
      return yield self, user
    else
      return yield self, nil
    end
  end
end
