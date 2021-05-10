class PasswordResets::NewPage < GuestLayout
  needs operation : User::ResetPassword

  def content
    shrink_to_fit do
      render_password_reset_form(@operation)
    end
  end

  private def render_password_reset_form(op)
    form_for PasswordResets::Create.route do
      mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input(autofocus: "true")
      mount Shared::Field, attribute: op.password_confirmation, label_text: "Confirm Password", &.password_input

      submit "Update Password", flow_id: "update-password-button"
    end
  end
end
