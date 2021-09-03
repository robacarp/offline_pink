class SaveFeature < Feature::SaveOperation
  permit_columns name

  before_save do
    state.value = Feature::State::Disabled
    editable.value = true
  end
end
