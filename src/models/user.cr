require "crypto/bcrypt/password"

class User < Granite::Base
  extend Granite::Query::BuilderMethods
  include RelativeTime

  adapter pg

  primary id : Int64
  field name : String
  field email : String
  field crypted_password : String

  field admin : Bool
  field activated : Bool

  @admin = false

  timestamps

  has_many :domains
  belongs_to :invite

  def validate : Nil
    messages = {
      unique: "is already registered",
      blank:  "cannot be blank"
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

  def self.guest_user : self
    new
  end

  def guest? : Bool
    new_record?
  end

  def admin? : Bool
    @admin || false
  end

  def activated? : Bool
    @activated || false
  end
end
