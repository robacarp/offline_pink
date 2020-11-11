class SaveDomain < Domain::SaveOperation
  permit_columns name

  needs user : User

  DNS_FORMAT = "should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail"
  DUPLICATE = "is already being checked"

  before_save do
    validate_required name
    validate_uniqueness_of name
  end

  before_save do
    user_id.value = user.id
    is_valid.value = true
    status_code.value = Domain::Status::UnChecked.value
  end

  before_save validate_dns_format

  after_save attach_default_monitors

  def attach_default_monitors(domain : Domain)
    Monitor::SaveICMP.create! domain
    Monitor::SaveHTTP.create! domain, path: "/", ssl: true, expected_status_code: 200
  end

  def validate_dns_format
    name.value.try do |domain_name|
      if domain_name.index("/") || domain_name[0...4] == "http"
        name.add_error DNS_FORMAT
      end
    end
  end
end
