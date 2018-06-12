.row
  .col-md-8.offset-md-2
    h3 User ##{user.id}

- if user.is? :admin
  .alert.alert-warning
    | This user is marked as an admin.

.row
  .col-md-8.offset-md-2
    table.table.table-dark
      tr
        th scope="row" Name
        td= user.name
      tr
        th scope="row" Email
        td= user.email
      tr
        th scope="row" Features
        td
          == form action: admin_user_features_path(user), method: :post do
            == csrf_tag
            - User::Feature.each do |feature, _|
              - feature_name = feature.to_s.underscore.gsub('_',' ').capitalize
              - label_name = "feature_#{feature.to_s.underscore}"
              == "<label for='#{label_name}'>"
              == "<input type='checkbox' name='feature' id='#{label_name}' value='#{feature.to_s}' #{user.can?(feature) ? "checked" : ""}>"
              = feature_name
              == "</label>"
              br
            == submit "Update features", class: "btn btn-primary btn-xs"
      tr
        th scope="row" Registered
        td
          = user.created_at
          | (#{user.relative_created_at})
