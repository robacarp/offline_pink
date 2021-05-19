class UserFactory < Avram::Factory
  def self.password
    "password"
  end

  def initialize
    email Faker::Internet.email
    encrypted_password Foundation::Authentication.encrypt_password(self.class.password)
  end
end
