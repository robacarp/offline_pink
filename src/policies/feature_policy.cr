class FeaturePolicy < ApplicationPolicy(Feature)
  def show?
    true
  end

  def index?
    true
  end
end
