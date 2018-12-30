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

  # def validate : Nil
  #   messages = {
  #     blank:      "cannot be blank",
  #     dns_format: "should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail",
  #     assigned:   "must be assigned",
  #     duplicate:  "is already being checked"
  #   }

  #   (add_error :name, messages[:blank];      return) unless @name
  #   (add_error :name, messages[:blank];      return) if @name.try(&.blank?)
  #   (add_error :name, messages[:dns_format]; return) if @name.try { |n| ! n.index("/").nil? || n[0...4] == "http" }
  #   (add_error :user, messages[:assigned];   return) unless @user_id

  #   if new_record?
  #     (add_error :name, messages[:duplicate];  return) if Domain.where(user_id: @user_id, name: @name).any?
  #   end
  # end
