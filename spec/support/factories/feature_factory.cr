class FeatureFactory < Avram::Factory
  def initialize
    name Faker::Internet.user_name
    editable true
    state Feature::State::Disabled
  end
end
