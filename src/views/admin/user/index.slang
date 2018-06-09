h3 Users

| There are #{user_count} users registered.

.row
  .col-md-8.offset-md-2
    table.table.table-dark.table-striped
      tr
        th scope="col" id
        th scope="col" email
        th scope="col" roles
      - users.each do |user|
        tr
          th scope="row" = user.id
          td
            a href="#{admin_user_path user}" = user.email
          td
            |
            - if user.is? :admin
              | admin
            - if user.is? :active
              | activated
