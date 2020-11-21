class OrganizationBox < Avram::Box
  def initialize
    name Faker::Address.country
  end
end
