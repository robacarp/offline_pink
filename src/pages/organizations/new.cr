class Organizations::NewPage < AuthLayout
  needs save : SaveOrganization

  def content
    fixed_width do
      h1 "Create an organization"

      form_for Organizations::Create do
        mount Shared::Field, attribute: save.name, &.text_input(autofocus: true)
        submit "Create"
      end
    end
  end
end
