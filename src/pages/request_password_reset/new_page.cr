class RequestPasswordReset::NewPage < GuestLayout
  needs operation : User::RequestPasswordReset

  def content
    small_frame do
      header_and_links "Request Password Reset"

      themed_form RequestPasswordReset::Create do
        mount Shared::Field, attribute: operation.email, label_text: "Email", &.email_input
        submit "Reset Password", flow_id: "request-password-reset-button"
      end
    end
  end
end
