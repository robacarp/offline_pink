class SessionForm < LuckyRecord::VirtualForm
  virtual email : String
  virtual password : String

  def submit
    validate_required email
    validate_required password

    unless valid?
      yield self, nil
      return
    end

    user = email.value.try do |value|
      UserQuery.new.email(value).first?
    end

    unless user
      email.add_error "is not in our system"
      yield self, nil
      return
    end

    if user.valid_password? password.value.to_s
      yield self, user
    else
      password.add_error "does not match"
      yield self, nil
    end
  end
end
