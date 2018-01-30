require "granite_orm/adapter/pg"
require "crypto/bcrypt/password"

class User < Granite::ORM::Base
  adapter pg

  field name : String
  field email : String
  field crypted_password : String
  timestamps

  has_many :checks

  def hash_password(unencrypted_password : String)
    @crypted_password = Crypto::Bcrypt::Password.create(unencrypted_password, cost: 10).to_s
  end

  def check_password(password_guess : String)
    if hash = @crypted_password
      Crypto::Bcrypt::Password.new(hash) == password_guess
    end
  end

  # for form views
  def password
  end

  def self.guest_user
    new
  end

  def admin?
    false
  end
end
