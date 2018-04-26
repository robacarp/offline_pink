.row
  .col-md-6.offset-md-3
    h1 Activate your account

    p Use of Offline.Pink is currently by invite only. Activate your account here.
    == form action: user_activation_path, method: :post do
      == csrf_tag
      div.form-group
        == text_field name: "invite_code", value: invite.code, placeholder: "Invite code", class: "form-control"
      div.form-group
        == submit "Submit", class: "btn btn-primary btn-xs"
