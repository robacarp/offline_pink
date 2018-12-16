class Session::NewPage < GuestLayout
  needs form : SessionForm

  def content
    div class: "row" do
      div class: "col-md-6 offset-md-3" do
        form_for Session::Create do
          field(@form.email) { |i| email_input i, autofocus: "true", class: "form-control" }
          field(@form.password) { |i| password_input i, class: "form-control" }

          div class: "form-gorup" do
            submit "Login", flow_id: "sign-in-button", class: "btn btn-primary btn-xs"
            link "Register", to: Registration::New
          end
        end

        # link "Reset password", to: PasswordResetRequests::New
      end
    end
  end

end
