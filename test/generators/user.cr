module Generate
  def user(**attributes)
    fields = {
      email: "test_user#{counter(:user)}@example.com",
      password: "12345"
    }.merge(attributes)

    password = fields[:password]

    User.new(**fields).tap do |u|
      u.hash_password password
    end
  end

  def user!(**attributes)
    user(**attributes).tap &.save
  end
end
