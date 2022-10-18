class Subscription < BaseModel
  table do
    column stripe_id : String
    column expires_at : Time = Time::UNIX_EPOCH
    belongs_to user : User
  end

  def active?
    expires_at > Time.utc
  end
end
