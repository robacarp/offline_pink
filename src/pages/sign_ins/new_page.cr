class SignIns::NewPage < GuestLayout
  needs operation : SignInUser

  def content
    small_frame do
      header_and_links "Sign In" do
        link "Sign up", to: SignUps::New
        middot_sep
        link "Forgot Password?", to: RequestPasswordReset::New
      end

      themed_form SignIns::Create do
        mount Shared::Field, attribute: operation.email, label_text: "Email", &.email_input(autofocus: "true", placeholder: "me@offline.pink")
        mount Shared::Field, attribute: operation.password, label_text: "Password", &.password_input(placeholder: "*************")

        div class: "button-group" do
          submit "Sign In", flow_id: "sign-in-button"
        end
      end
    end
  end
end
