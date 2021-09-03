class Feature < BaseModel
  enum State
    Enabled = 0
    Disabled = 1
    Grantable = 2
  end

  table do
    column name : String
    column state : Feature::State
    column editable : Bool

    has_many grants : EnabledFeature
  end

  def self.query
    FeatureQuery.new
  end

  def self.states_for_select
    State.names.zip(State.values.map(&.to_i)).to_h
  end
end
