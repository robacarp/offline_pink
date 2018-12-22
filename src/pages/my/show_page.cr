class Me::ShowPage < MainLayout
  needs form : AccountForm

  def content
    div ".row" do
      div ".col-md-6.offset-md-3" do
        h3 "Account"

        form_for Me::Update do
          h4 "Credentials"
          para "To update email or password, provide your current password."
          div ".form-group" do
            field(@form.password, hide_label: true) { |i| password_input i, autofocus: true, class: "form-control", placeholder: "Current Password" }
            br
            field(@form.email, hide_label: true) { |i| email_input i, placeholder: "Email", class: "form-control" }
            br
            field(@form.new_password, hide_label: true) { |i| password_input i, placeholder: "New Password", class: "form-control" }
          end

          div ".form-group" do
            submit "Save", class: "btn btn-primary btn-xs"
          end
        end
      end
    end
  end
end
