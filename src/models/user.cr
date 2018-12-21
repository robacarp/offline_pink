require "./user/*"

class User < BaseModel
  include Carbon::Emailable

  include Password
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

  end
end
