require "./user/*"
require "./domain"

class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  include Features

  table :users do
    column email : String
    column encrypted_password : String
    column features : Int32

    has_many domains : Domain
  end

  def features
    previous_def || 0
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end

  def activated?
    is? :active
  end
end
