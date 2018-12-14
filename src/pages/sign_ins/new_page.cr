class SignIns::NewPage < GuestLayout
  needs form : SignInForm

  def content
    div class: "row" do
      div class: "col-md-6 offset-md-3" do
        form_for SignIns::Create do
          field(@form.email) { |i| email_input i, autofocus: "true", class: "form-control" }
          field(@form.password) { |i| password_input i, class: "form-control" }

          div class: "form-gorup" do
            submit "Login", flow_id: "sign-in-button", class: "btn btn-primary btn-xs"
            link "Register", to: SignUps::New
          end
        end

        # link "Reset password", to: PasswordResetRequests::New
      end
    end
  end

end
