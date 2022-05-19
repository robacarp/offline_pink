class Organizations::NewPage < AuthLayout
  needs save : SaveOrganization

  def content
    small_frame do
      header_and_links do
        h1 "Create an organization"
      end

      centered do
        form_for Organizations::Create do
          mount Shared::Field,
            attribute: save.name,
            label_text: "Organization Name",
            button: { text: "Create" },
            &.text_input(autofocus: true)
        end
      end
    end
  end
end
