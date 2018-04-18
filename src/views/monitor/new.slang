.row
  .col-md-6.offset-md-3
    h3
      | New monitor for
      = domain.name

    - if monitor.errors
      ul.errors
        - monitor.errors.each do |error|
          li = error.to_s


    == form action: "#{new_domain_monitor_path domain}", method: :post do
      == csrf_tag
      .form_group
        == label :monitor_type, "Monitor Type"
        == select_field name: :monitor_type, collection: Monitor::VALID_TYPES.invert
      .form_group.ping
      .form_group.http
        == label :http_path, "Path to request"
        == text_field name: :http_path, value: monitor.http_path, placeholder: "/", class: "form-control"
      .form_group
        == label :http_expected_content, "Expected text to search for"
        == text_field name: :http_expected_content, value: monitor.http_expected_content, placeholder: "<html>", class: "form-control"
      .form_group
        == label :http_expected_status_code, "Expected HTTP Status Code"
        == text_field name: :http_expected_status_code, value: monitor.http_expected_status_code, placeholder: "200", class: "form-control"
      .form_group
        == check_box name: :http_use_ssl, checked: monitor.https?
        == label :http_use_ssl, "Use SSL?"
      .form_group
        == submit "Submit", class: "btn"
