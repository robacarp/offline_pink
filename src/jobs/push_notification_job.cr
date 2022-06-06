class PushNotificationJob < Mosquito::QueuedJob
  params(
    user_id : Int64,
    title : String,
    notification : String
  )

  def perform
    return unless push_enabled?
    user = UserQuery.new.find user_id
    return unless pushover_key = user.pushover_key

    Pushover::API.new.send(
      user_key: pushover_key,
      title: title,
      message: notification
    )
  end

  def push_enabled?
    unless Featurette[:push_notifications].enabled?(for: user_id)
      log "refusing to send notification because user #{user_id} is not enabled for push notification"
      return false
    end

    true
  end
end
