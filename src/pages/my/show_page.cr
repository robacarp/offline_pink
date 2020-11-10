class Me::ShowPage < AuthLayout
  needs user : User

  def content
    fixed_width do
      h1 "This is your profile"
      h3 "Email:  #{user.email}"
    end
  end
end
