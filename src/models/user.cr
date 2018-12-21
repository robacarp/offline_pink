class User < BaseModel
  include Carbon::Emailable

  table :users do
    column email : String
    column crypted_password : String
    column features : Int32
  end

  def features
    previous_def || 0
  end

  def emailable
    Carbon::Address.new(email)
  end

  def self.hash_password(unencrypted_password : String)
    Crypto::Bcrypt::Password.create(unencrypted_password, cost: 10).to_s
  end

  def valid_password?(password_guess : String)
    if hash = @crypted_password
      Crypto::Bcrypt::Password.new(hash) == password_guess
    end
  end
end
