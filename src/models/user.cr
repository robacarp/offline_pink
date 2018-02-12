require "granite_orm/adapter/pg"
require "crypto/bcrypt/password"

class User < Granite::ORM::Base
  extend Query::BuilderMethods
  include RelativeTime

  adapter pg

  field name : String
  field email : String
  field crypted_password : String

  field admin : Bool

  @admin = false

  timestamps

  has_many :domains

  def validate : Nil
    messages = {
      unique: "is already registered"
      blank:  "cannot be blank",
    }

    (add_error :email, messages[:blank]; return) unless @email
    (add_error :email, messages[:blank]; return) if @email.try &.blank?

    unless password_hash = @crypted_password
      add_error :password, messages[:blank]
      return
    end

    if new_record? && User.where(email: @email).count > 0
      add_error :email, messages[:unique]
      return
    end
  end

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

  def admin? : Bool
    @admin
  end
end
