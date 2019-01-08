class DomainForm < Domain::BaseForm
  fillable name

  needs user : User

  DNS_FORMAT = "should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail"
  DUPLICATE = "is already being checked"

  def prepare
    user_id.value = user.id
    is_valid.value = true
    status_code.value = Domain::Status::UnChecked.value

    validate_required name
    validate_uniqueness_of name

    name.value.try do |domain_name|
      name.add_error DNS_FORMAT if domain_name.index("/") || domain_name[0...4] == "http"
    end
  end
end
