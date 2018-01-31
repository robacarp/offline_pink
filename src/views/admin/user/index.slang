h3 Users

| There are #{user_count} users registered.
| #{admin_count} are marked as admin.

.row
  .col-md-8.offset-md-2
    table.table.table-dark.table-striped
      tr
        th scope="col" id
        th scope="col" email
      - users.each do |user|
        tr
          th scope="row" = user.id
          td
            a href="/admin/user/#{user.id}" = user.email
