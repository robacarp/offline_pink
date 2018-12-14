class SignUps::NewPage < GuestLayout
  needs form : SignUpForm

  def content
    div class: "row" do
      div class: "col-md-6 offset-md-3" do
        h1 "Register"

        div class: "alert alert-info" do
          text "Use of Offline.Pink is currently by invite only. You can register for an account but will not be able to use Offline.pink for monitoring until your account is activated."
        end

        form_for SignUps::Create do
          field(@form.email) { |i| email_input i, autofocus: "true", class: "form-control" }
          field(@form.password) { |i| password_input i, class: "form-control" }
          field(@form.password_confirmation) { |i| password_input i, class: "form-control" }

          div class: "form-group" do
            submit "Register", flow_id: "sign-up-button", class: "btn btn-primary btn-xs"
            link "Log in", to: SignIns::New
          end
        end

      end
    end
  end

end
