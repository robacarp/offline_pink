h3 User ##{user.id}

- if user.admin?
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
        th scope="row" Registered
        td
          = user.created_at
          | (#{user.relative_created_at})
