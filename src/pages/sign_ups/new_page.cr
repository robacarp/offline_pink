class SignUps::NewPage < GuestLayout
  needs operation : SignUpUser

  def content
    div class: "authentication-form" do
      render_sign_up_form(@operation)
    end
  end

  private def render_sign_up_form(op)
    form_for SignUps::Create do
      mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input(autofocus: "true")
      mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input(placeholder: "****************")
      mount Shared::Field, attribute: op.password_confirmation, label_text: "Confirm Password", &.password_input(placeholder: "****************")

      div class: "button-group" do
        submit "Sign Up", flow_id: "sign-up-button"

        div class: "flex flex-col items-end" do
          link "Sign in instead", to: SignIns::New
        end
      end
    end
  end
end
