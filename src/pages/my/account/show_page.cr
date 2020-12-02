class My::Account::ShowPage < AuthLayout
  needs user : User
  needs save : SaveUser

  def content
    small_frame do
      div class: "flex justify-between items-end" do
        h1 "Your Account"

        div do
        link "Sign out", to: SignIns::Delete
        raw "&nbsp;&middot;&nbsp;"
        link "Change your password", to: My::Password::Change
        end
      end

      hr

      form_for My::Account::Update do
        mount Shared::Field, attribute: save.email, button: { text: "Save" }, &.text_input
      end


      if (memberships = user.memberships!).any?
        div class: "flex justify-between items-end" do
          h1 "Organization Membership"
          link "Create a new Organization", to: Organizations::New
        end

        hr

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
