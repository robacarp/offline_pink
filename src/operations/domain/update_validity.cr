class DomainOp::UpdateValidity < Domain::SaveOperation
  after_commit send_notification

  before_save do
    if is_valid.value == false
      status_code.value = Domain::Status::Offline
    end
  end

  def send_notification(domain)
    if is_valid.changed?
      Notify::Domain.new(domain).update_validity
    end
  end
end
