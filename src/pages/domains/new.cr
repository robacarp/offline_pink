class Domains::NewPage < AuthLayout
  needs save : SaveDomain

  def content
    fixed_width do
      h1 "Monitor new domain"

      form_for Domains::Create do
        mount Shared::Field, attribute: save.name, &.text_input(autofocus: true)
        submit "Submit"
      end
    end
  end
end
