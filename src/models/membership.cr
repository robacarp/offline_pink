class Membership < BaseModel
  table do
    belongs_to user : User
    belongs_to organization : Organization
    column admin : Bool = false
    column pending : Bool = true
  end
end
