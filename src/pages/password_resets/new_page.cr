class PasswordReset::NewPage < GuestLayout
  needs operation : User::ResetPassword

  def content
    small_frame do
      header_and_links "Reset your password"

      form_for PasswordReset::Create.route do
        mount Shared::Field, attribute: operation.password, label_text: "Password", &.password_input(autofocus: "true")
        mount Shared::Field, attribute: operation.password_confirmation, label_text: "Confirm Password", &.password_input

        submit "Update Password", flow_id: "update-password-button"
      end
    end
  end
end
