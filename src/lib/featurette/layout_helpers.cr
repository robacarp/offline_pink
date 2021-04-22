module Featurette
  module LayoutHelpers(FeatureModel)
    Log = ::Log.for("featurette")

    def feature_enabled?(feature_name : Symbol) : Bool
      return false unless feature = lookup_feature(feature_name.to_s)

      case feature.state
      when .enabled?
        true
      when .grantable?
        if user = current_user
          user.features.map(&.id).includes?(feature.id)
        else
          false
        end
      when .disabled?
        false
      else
        false
      end
    end

    private def lookup_feature(feature_name : String) : FeatureModel?
      FeatureModel.query.name(feature_name.to_s).first?.tap do |feature|
        Log.warn { "Could not find feature '#{feature_name}'" } unless feature
      end
    end
  end
end
