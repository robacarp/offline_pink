require "./user/*"
require "./domain"

class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  include Features

  table :users do
    column email : String
    column encrypted_password : String
    column features : Int32 = 0
    column pushover_key : String?
    column pushover_key_valid : Bool = false
    column email_valid : Bool = false

    has_many domains : Domain
    has_many memberships : Membership
    has_many organizations : Organization, through: [:memberships, :user]
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end

  def activated?
    is? :active
  end
end
