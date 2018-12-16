class SessionForm < LuckyRecord::VirtualForm
  include Authentic::FormHelpers
  include FindAuthenticatable

  virtual email : String
  virtual password : String

  # This method is called to allow you to determine if a user can sign in.
  # By default it validates that the user exists and the password is correct.
  private def find_authenticatable
    email.value.try do |value|
      UserQuery.new.email(value).first?
    end
  end

  private def validate(user : User?)
    if user
      unless user.valid_password? password.value.to_s
        password.add_error "is wrong"
      end
    else
      email.add_error "is not in our system"
    end
  end
end
