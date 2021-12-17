module Featurette
  class DisabledFeatureError < Exception
  end

  module ActionHelpers
    macro ensure_feature_permitted(name)
      before _ensure_feature_{{ name.id }}

      def _ensure_feature_{{ name.id }}
        feature_name = "{{ name.id }}"
        features = current_user.features.map(&.name)

        if features.includes? feature_name
          continue
        else
          if FeatureQuery.new.name(feature_name).state(Feature::State::Enabled).any?

            continue
          else
            raise Featurette::DisabledFeatureError.new("#{current_user.id} cannot '#{feature_name}' (can: #{features.join(", ")})")
          end
        end
      end
    end

    macro allow_feature_bypass(name)
      skip _ensure_feature_{{ name.id }}
    end
  end
end
