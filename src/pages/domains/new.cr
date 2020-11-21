class Domains::NewPage < AuthLayout
  needs save : SaveDomain

  def content
    shrink_to_fit do
      form_for Domains::Create do
        h1 "Monitor new domain"
        hr

        mount Shared::OwnershipDropdown, attribute: save.owner, possible_owners: possible_owners
        mount Shared::Field, attribute: save.name, label_text: "DNS Name", &.text_input(autofocus: true, placeholder: "google.com")

        submit "Submit"
      end
    end
  end
end
