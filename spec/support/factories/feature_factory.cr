class Featurette::FeatureFactory < Avram::Factory
  def initialize
    name Faker::Internet.user_name
    editable true
    state Featurette::Feature::State::Disabled
  end
end
