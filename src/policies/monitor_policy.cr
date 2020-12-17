class MonitorPolicy < Monitor::BasePolicy
  private def domain_policy
    DomainPolicy.new(user, object.domain!)
  end

  def read?
    domain_policy.read?
  end

  def delete?
    domain_policy.update?
  end
end
