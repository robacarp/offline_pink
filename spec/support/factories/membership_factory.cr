class MembershipFactory < Avram::Factory
  def initialize
    pending false
    admin false
  end
end
