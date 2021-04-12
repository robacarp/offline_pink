class EnabledFeature < BaseModel
  table do
    belongs_to feature : Feature
    belongs_to user : User
  end
end
