module Featurette
  class DisabledFeatureError < Exception
  end

  module ActionHelpers
    macro ensure_feature_permitted(name)
      before _ensure_feature

      def _ensure_feature
        feature = "{{ name.id }}"
        if current_user.features.map(&.name).includes? feature
          continue
        else
          raise Featurette::DisabledFeatureError.new
        end
      end
    end
  end
end
