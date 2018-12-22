module Password
  macro included
    extend ClassMethods
  end

  module ClassMethods
    def hash_password(unencrypted_password : String)
      Crypto::Bcrypt::Password.create(unencrypted_password, cost: 10).to_s
    end
  end

  def valid_password?(password_guess : String?)
    if password_guess
      if hash = @crypted_password
        Crypto::Bcrypt::Password.new(hash) == password_guess
      end
    else
      false
    end
  end
end
