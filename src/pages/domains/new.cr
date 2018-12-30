class Domains::NewPage < MainLayout
  needs form : DomainForm

  def content
    div ".row" do
      div ".col-md-6.offset-md-3" do
        h1 "Monitor new domain"

        form_for Domains::Create do
          field(@form.name) { |i| text_input i, autofocus: "true", class: "form_control" }

          submit "Submit", class: "btn btn-primary btn-xs"
        end
      end
    end
  end
end
