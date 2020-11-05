class Domains::NewPage < AuthLayout
  needs save : SaveDomain

  def content
    div class: "row" do
      div class: "col-md-6 offset-md-3" do
        h1 "Monitor new domain"

        form_for Domains::Create do
          text_input save.name, autofocus: "true", class: "form_control"

          submit "Submit", class: "btn btn-primary btn-xs"
        end
      end
    end
  end
end
