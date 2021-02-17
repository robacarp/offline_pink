class OrganizationFactory < Avram::Factory
  def initialize
    name Faker::Address.country
  end
end
