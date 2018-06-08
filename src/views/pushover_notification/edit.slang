.row
  .col-md-6.offset-md-3
    h3 Pushover Notification

    - if key.verified?
      .alert.alert-success Your Pushover notification key is verified and will receive notifications

    - else
      - unless key.new_record?
        .alert.alert-danger
          | Your Pushover notification key is not verified and will not receive notifications yet.
          == form action: pushover_verification_path, method: :post do
            == submit "Verify Now", class: "btn"

    == form action: pushover_notification_settings_path, method: :post do
      == csrf_tag
      .form_group
        p
          | Notifications via
          a href="https://pushover.net/" Pushover
          | require your user key.
        == text_field name: :pushover_key, value: key.masked, placeholder: "Pushover User Key", class: "form-control"

      .form_group
        == submit "Submit", class: "btn"
