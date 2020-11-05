class Monitors::ICMP::Save < Monitors::ICMP::SaveOperation
  needs domain : Domain

  def prepare
    validates_uniqueness_of domain_id
  end
end
