class SaveDomain < Domain::SaveOperation
  permit_columns name

  attribute owner : String

  DNS_FORMAT = "should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail"

  before_save validate_dns_format
  before_save validate_owner_is_assigned

  before_save do
    is_valid.value = true
    status_code.value = Domain::Status::UnChecked

    validate_required owner
    validate_required name
    validate_uniqueness_of name
  end

  after_save attach_default_monitors
  after_save enqueue_monitor

  def validate_dns_format
    name.value.try do |domain_name|
      if domain_name.index("/") || domain_name[0...4] == "http"
        name.add_error DNS_FORMAT
      end
    end
  end

  def validate_owner_is_assigned
    owner.add_error if user_id.blank? && organization_id.blank?
  end

  def attach_default_monitors(domain : Domain)
    SaveIcmpMonitor.create! domain
    SaveHttpMonitor.create! domain, path: "/", ssl: true, expected_status_code: 200
  end

  def enqueue_monitor(domain : Domain)
    MonitorJob.new(domain_id: domain.id).enqueue
  end
end
