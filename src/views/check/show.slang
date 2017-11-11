.row
  .col-md-6
    h3 = "#{check.host}#{check.url}"

    table.table.table-sm.table-hover
      tr
        th scope="row" Last Ping

  .col-md-6.text-right
    a.btn.btn-xs href="/checks/#{ check.id }/edit" edit
    a.btn.btn-xs href="/checks/#{ check.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
