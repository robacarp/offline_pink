class Feature < BaseModel
  avram_enum State do
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
end
