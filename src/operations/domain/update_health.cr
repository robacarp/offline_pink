class DomainOp::UpdateHealth < Domain::SaveOperation
  after_commit send_notification

  def send_notification(domain)
    if status_code.changed?
      NotificationJob.new(domain.id, notification_message(domain)).enqueue
    end
  end

  def notification_message(domain)
    case status_code.value
    when Domain::Status::Stable
      "#{domain.name} is stable"
    when Domain::Status::Degraded
      "#{domain.name} is degraded"
    when Domain::Status::Offline
      "#{domain.name} is offline"
    else
      raise "Unable to notify Domain##{domain.id} for status #{status_code.value}"
    end
  end
end
