class SignIns::NewPage < GuestLayout
  needs operation : SignInUser

  def content
    shrink_to_fit do
      render_sign_in_form @operation
    end
  end

  private def render_sign_in_form(op)
    form_for SignIns::Create do
      mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input(autofocus: "true", placeholder: "me@offline.pink")
      mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input(placeholder: "*************")

      div class: "button-group" do
        submit "Sign In", flow_id: "sign-in-button"

        div class: "flex flex-col items-end" do
          link "Sign up", to: SignUps::New
          link "Forgot Password?", to: PasswordResetRequests::New
        end
      end
    end
  end
end
