class My::Account::ShowPage < AuthLayout
  needs user : User
  needs save : SaveUser

  def content
    small_frame do
      header_and_links do
        h1 "Your Account"

        div do
          link "Sign out", to: SignIns::Delete
          middot_sep
          link "Change your password", to: My::Password::Change
        end
      end

      form_for My::Account::Update do
        mount Shared::Field, attribute: save.email, &.text_input
        mount Shared::Field, attribute: save.pushover_key, &.text_input
        submit "Save"
      end

      if (memberships = user.memberships!).any?
        header_and_links do
          h1 "Organization Membership"
          link "Create a new Organization", to: Organizations::New
        end

        table do
         memberships.each do |membership|
           organization_row membership
         end
        end
      end

    end
  end

  private def organization_row(membership)
    organization = membership.organization!

    tr do
      td do
        link organization.name, to: Organizations::Show.route(organization)
      end

      td do
        if membership.admin?
          text "Admin"
        end
      end
    end
  end
end
