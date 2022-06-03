class SaveFeature < Featurette::Feature::SaveOperation
  permit_columns name

  before_save do
    state.value = Featurette::Feature::State::Disabled
    editable.value = true
  end
end
