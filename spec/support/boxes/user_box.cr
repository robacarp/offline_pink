class UserBox < Avram::Box
  def initialize
    email Faker::Internet.email
    encrypted_password Authentic.generate_encrypted_password("password")
  end
end
