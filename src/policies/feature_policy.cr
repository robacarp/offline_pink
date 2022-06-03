class FeaturePolicy < ApplicationPolicy(Featurette::Feature)
  def show?
    true
  end

  def index?
    true
  end
end
