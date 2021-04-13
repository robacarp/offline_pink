class PasswordResetRequests::NewPage < GuestLayout
  needs operation : RequestPasswordReset

  def content
    shrink_to_fit do
      render_form(@operation)
    end
  end

  private def render_form(op)
    form_for PasswordResetRequests::Create do
      mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input
      submit "Reset Password", flow_id: "request-password-reset-button"
    end
  end
end
