class Domains::NewPage < AuthLayout
  needs save : SaveDomain

  def content
    small_frame do
      h1 "Monitor new domain"
      hr

      shrink_to_fit do
        form_for Domains::Create do
          mount Shared::OwnershipDropdown, attribute: save.owner, possible_owners: possible_owners
          mount Shared::Field, attribute: save.name, label_text: "DNS Name", &.text_input(autofocus: true, placeholder: "google.com")

          shrink_to_fit do
            submit "Submit"
          end
        end
      end
    end
  end
end
