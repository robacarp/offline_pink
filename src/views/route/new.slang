.row
  .col-md-6.offset-md-3
    h1 Monitor route for #{domain.name}
    - if route.errors
      ul.errors
        - route.errors.each do |error|
          li = error.to_s

    == form action: "/domain/#{domain.id}/routes/new", method: :post do
      == csrf_tag
      .form_group
        == label :path, "Path to request"
        == text_field name: :path, value: route.path, placeholder: "/", class: "form-control"
      .form_group
        == label :expected_content, "Expected text to search for"
        == text_field name: :expected_content, value: route.expected_content, placeholder: "<html>", class: "form-control"
      .form_group
        == label :expected_code, "Expected HTTP Status Code"
        == text_field name: :expected_code, value: route.expected_code, placeholder: "200", class: "form-control"
      .form_group
        == check_box name: :use_ssl, checked: route.use_ssl?
        == label :use_ssl, "Use SSL?"
      .form_group
        == submit "Submit", class: "btn"
