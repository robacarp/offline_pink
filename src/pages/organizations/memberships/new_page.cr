class Organizations::Memberships::NewPage < AuthLayout
  needs organization : Organization
  needs save : SaveInvite

  def content
    fixed_width do
      h1 do
        text "Invite someone to "
        text organization.name

        themed_form Organizations::Memberships::Create.route(organization.id) do
          mount Shared::Field, attribute: save.email, &.email_input(autofocus: true)
          submit "Invite"
        end
      end
    end
  end
end
