class My::Domains::NewPage < AuthLayout
  needs save : SaveDomain

  def content
    small_frame do
      header_and_links do
        h1 "Monitor new domain"
      end

      centered do
        themed_form Domains::Create do
          mount Shared::OwnershipDropdown, attribute: save.owner, possible_owners: possible_owners
          mount Shared::Field, attribute: save.name, label_text: "DNS Name", &.text_input(autofocus: true, placeholder: "google.com")

          centered do
            submit "Submit"
          end
        end
      end
    end
  end
end
