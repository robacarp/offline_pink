class SignUps::NewPage < GuestLayout
  needs operation : SignUpUser

  def content
    small_frame do
      header_and_links "Sign Up" do
        link "Sign in", to: SignIns::New
      end

      themed_form SignUps::Create do
        mount Shared::Field, attribute: operation.email, label_text: "Email", &.email_input(autofocus: "true")
        mount Shared::Field, attribute: operation.password, label_text: "Password", &.password_input(placeholder: "****************")
        mount Shared::Field, attribute: operation.password_confirmation, label_text: "Confirm Password", &.password_input(placeholder: "****************")

        div class: "button-group" do
          submit "Sign Up", flow_id: "sign-up-button"
        end
      end
    end
  end
end
