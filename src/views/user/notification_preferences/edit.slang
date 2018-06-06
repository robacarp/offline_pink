.row
  .col-md-6.offset-md-3
    h3 Notification Preferences

    == form action: notification_preferences_path, method: :post do
      == csrf_tag
      .form_group
        h4 Pushover
        p
          | Notifications via
          a href="https://pushover.net/" Pushover
          | require your user key.
        == text_field name: :pushover_key, value: user.masked_pushover_key, placeholder: "Pushover User Key", class: "form-control"

      .form_group
        == submit "Submit", class: "btn"
