class ToggleFeature < Feature::SaveOperation
  permit_columns state
end
