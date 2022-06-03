module Featurette
  def self.[](name)
    if feature = FeatureQuery.new.name(name.to_s).first?
      feature
    else
      DisabledFeature.new
    end
  end

  class DisabledFeature
    def enabled?
      false
    end

    def enabled?(for user_id)
      false
    end
  end
end
