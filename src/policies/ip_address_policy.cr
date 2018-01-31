class IpAddressPolicy < ApplicationPolicy
  default_policy_for IpAddress

  def user_is_domain_owner?
    query = <<-SQL
      JOIN domains ON domains.id = ip_addresses.domain_id
      WHERE domains.user_id = ?
    SQL

    IpAddress.all query, current_user.id
  end

  def delete?
    user_is_domain_owner?
  end

  def destroy?
    user_is_domain_owner?
  end
end
