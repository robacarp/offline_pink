class ToggleFeature < Featurette::Feature::SaveOperation
  permit_columns state
end
