class PushNotificationJob < Mosquito::QueuedJob
  params(
    user_id : Int64,
    title : String,
    notification : String
  )

  def perform
    user = UserQuery.new.find user_id
    return unless pushover_key = user.pushover_key

    Pushover::API.new.send(
      user_key: pushover_key,
      title: title,
      message: notification
    )
  end
end
