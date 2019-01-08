class Monitors::ICMP::Form < Monitors::ICMP::BaseForm
  needs domain : Domain

  def prepare
    validates_uniqueness_of domain_id
  end
end
