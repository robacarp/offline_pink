require "./user/*"
require "./domain"

class User < BaseModel
  include Carbon::Emailable

  include Password
  include Features

  table :users do
    column email : String
    column crypted_password : String
    column features : Int32

    has_many domains : Domain
  end

  def features
    previous_def || 0
  end

  def emailable
    Carbon::Address.new(email)
  end

  def activated?
    is? :active
  end
end
