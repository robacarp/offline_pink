class EmailNotificationJob < Mosquito::QueuedJob
  params(
    user_id : Int64,
    subject : String,
    body : String
  )

  def perform
  end
end
