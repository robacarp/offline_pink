class MonitorPolicy < ApplicationPolicy(Monitor)
  private def domain_policy
    DomainPolicy.new(user, record.domain!)
  end

  def read?
    domain_policy.read?
  end

  def delete?
    domain_policy.update?
  end
end
