class DomainOp::UpdateValidity < Domain::SaveOperation
  after_commit send_notification

  def send_notification(domain)
    if is_valid.changed?
      NotificationJob.new(domain.id, notification_message(domain)).enqueue
    end
  end

  def notification_message(domain)
    if is_valid.value
      "#{domain.name} is now valid for monitoring"
    else
      "#{domain.name} is no longer valid for monitoring"
    end
  end
end
