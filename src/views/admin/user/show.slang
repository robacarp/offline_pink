.row
  .col-md-8.offset-md-2
    h3 User ##{user.id}

- if user.is? :admin
  .alert.alert-warning
    | This user is marked as an admin.

.row
  .col-md-8.offset-md-2
    h4 Actions
    ul
      li
        - if user.is? :active
          == button_to "Deactivate", admin_deactivate_user_path(user)
        - else
          == button_to "Activate", admin_activate_user_path(user)
    table.table.table-dark
      tr
        th scope="row" Name
        td= user.name
      tr
        th scope="row" Email
        td= user.email
      tr
        th scope="row" Flags
        td
          - if user.is? :admin
            | admin
          - if user.is? :active
            | activated
          - else
            .pink deactivated
      tr
        th scope="row" Registered
        td
          = user.created_at
          | (#{user.relative_created_at})
