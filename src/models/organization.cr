class Organization < BaseModel
  table :organizations do
    column name : String

    has_many memberships : Membership
    has_many users : User, through: :memberships
    has_many domains : Domain
  end

  policy!
end
