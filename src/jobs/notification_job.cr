class NotificationJob < Mosquito::QueuedJob
  params(domain : Domain | Nil)

  def perform
    user = present_domain.user
    unless key = user.pushover_key
      log "No pushover key found, not notifying user."
      return
    end

    Pushover.new(user_key: key).send(
      title: "Test Message", message: "Message Body"
    )
  end

  def present_domain
    domain.not_nil!
  end
end
