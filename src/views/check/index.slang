div.row
  div.col-sm-11
    h2 Checks
  div.col-sm-1
    a.btn.btn-success.btn-xs href="/checks/new" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Get Request
        th Ping Check
        th Host
        th Url
        th Actions
    tbody
    - checks.each do |check|
      tr
        td = check.get_request
        td = check.ping_check
        td = check.host
        td = check.url
        td
          span
            a.btn.btn-primary.btn-xs href="/checks/#{ check.id }" read
            a.btn.btn-success.btn-xs href="/checks/#{ check.id }/edit" edit
            a.btn.btn-danger.btn-xs href="/checks/#{ check.id }?_method=delete" onclick="return confirm('Are you sure?');" delete

