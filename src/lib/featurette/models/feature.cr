module Featurette
  class Feature < BaseModel
    enum State
      Enabled = 0
      Disabled = 1
      Grantable = 2
    end

    table :features do
      column name : String
      column state : Featurette::Feature::State
      column editable : Bool

      has_many grants : EnabledFeature
    end

    def self.query
      FeatureQuery.new
    end

    def self.states_for_select
      State.names.zip(State.values.map(&.to_i)).to_h
    end

    def enabled? : Bool
      state == State::Enabled
    end

    def enabled?(for user_id) : Bool
      return false unless enabled?
      EnabledFeatureQuery.new
        .feature_id(id)
        .user_id(user_id)
        .any?
    end
  end
end
