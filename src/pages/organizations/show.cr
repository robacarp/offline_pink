class Organizations::ShowPage < AuthLayout
  needs organization : Organization

  def content
    fixed_width do

      h1 do
        text "Organization "
        text organization.name
      end
      h2 "Members:"

      if (memberships = organization.memberships).any?
        ul do
          memberships.each do |membership|
            li membership.user.email
          end
        end
      end

    end
  end

end
