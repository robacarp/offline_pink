class Registration::NewPage < GuestLayout
  needs form : RegistrationForm

  def content
    div ".row" do
      div ".col-md-6.offset-md-3" do
        h1 "Register"

        div ".alert.alert-info" do
          text "Use of offline.pink is currently by invite only. You can register for an account but will not be able to use offline.pink for monitoring until your account is activated."
        end

        form_for Registration::Create do
          field(@form.email) { |i| email_input i, autofocus: "true", class: "form-control" }
          field(@form.password) { |i| password_input i, class: "form-control" }

          div ".form-group" do
            submit "Register", flow_id: "sign-up-button", class: "btn btn-primary btn-xs"
            link "Log in", to: Session::New
          end
        end

      end
    end
  end

end
