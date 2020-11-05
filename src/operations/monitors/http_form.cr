class Monitors::HTTP::Save < Monitors::HTTP::SaveOperation
  needs domain : Domain

  def prepare
    validates_uniqueness_of domain_id
  end
end
