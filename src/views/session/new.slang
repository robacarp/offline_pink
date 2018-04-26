.row
  .col-md-6.offset-md-3
    == form method: "POST", action: new_session_path do
      == csrf_tag
      div.form-group
        == text_field name: "email", value: email, placeholder: "Email", class: "form-control"
      div.form-group
        == input_field type: :password, name: "password", value: password, placeholder: "Password", class: "form-control"
      div.form-group
        == submit "Login", class: "btn btn-primary"
        a href="#{new_user_path}" Register
