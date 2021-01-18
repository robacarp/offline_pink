class NotificationJob < Mosquito::QueuedJob
  params(
    domain_id : Int64,
    notification : String
  )

  def perform
  end
end

class PushoverTokenValidationJob < Mosquito::QueuedJob
  params(user_id : Int64)

  def perform
    # https://api.pushover.net/1/users/validate.json
    puts "TODO: actually validate a pushover token"
    update = User::SaveOperation.new(UserQuery.new.find user_id)
    update.pushover_key_valid.value = true
    update.save!
  end
end
