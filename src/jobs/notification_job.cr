module PushoverJobScheduling
end

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
    user = UserQuery.new.find user_id

    return unless key = user.pushover_key

    did_validate = Pushover.new.validate_user_key key

    update = User::SaveOperation.new user
    update.pushover_key_valid.value = did_validate
    update.save!
  end

  def rescheduleable? : Bool
    false
  end
end
