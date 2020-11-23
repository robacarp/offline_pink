class Organization < BaseModel
  table :organizations do
    column name : String

    has_many memberships : Membership
    has_many users : User, through: :memberships
  end

  policy!
end
