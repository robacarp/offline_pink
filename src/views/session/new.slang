.row
  .col-md-6.offset-md-3
    == form method: "POST", action: "/sessions/create" do
      == csrf_tag
      div.form-group
        == text_field name: "email", value: email, placeholder: "Email", class: "form-control"
      div.form-group
        == text_field name: "password", value: password, placeholder: "Password", class: "form-control"
      div.form-group
        == submit "Login"
        a href="/me/register" Register
