class Me::ShowPage < AuthLayout
  needs user : User

  def content
    fixed_width do
      h1 "This is your profile"
      h3 "Email:  #{user.email}"
      hr

      if (organizations = user.organizations!).any?
        para "You are a member of:"

        ul do
         organizations.each do |organization|
            li do
              link organization.name, to: Organizations::Show.route(organization)
            end
          end
        end
      end

      link "Create a new Organization", to: Organizations::New

      link "Sign out", to: SignIns::Delete
    end
  end
end
