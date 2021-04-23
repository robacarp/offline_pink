class SaveFeature < Feature::SaveOperation
  permit_columns name

  before_save do
    state.value = Feature::State.new :disabled
    editable.value = true
  end
end
