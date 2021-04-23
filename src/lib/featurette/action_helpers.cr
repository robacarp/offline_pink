module Featurette
  class DisabledFeatureError < Exception
  end

  module ActionHelpers
    macro ensure_feature_permitted(name)
      before _ensure_feature

      def _ensure_feature
        feature_name = "{{ name.id }}"
        features = current_user.features.map(&.name)

        if features.includes? feature_name
          continue
        else
          if FeatureQuery.new.name(feature_name).state(Feature::State.new(:enabled).to_i).any?
            continue
          else
            raise Featurette::DisabledFeatureError.new("#{current_user.id} cannot '#{feature_name}' (can: #{features.join(", ")})")
          end
        end
      end
    end
  end
end
