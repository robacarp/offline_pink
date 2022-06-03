module Featurette
  class EnabledFeature < BaseModel
    table :enabled_features do
      belongs_to feature : Featurette::Feature
      belongs_to user : User
    end
  end
end
