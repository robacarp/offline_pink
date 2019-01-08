class Monitors::HTTP::Form < Monitors::HTTP::BaseForm
  needs domain : Domain

  def prepare
    validates_uniqueness_of domain_id
  end
end
