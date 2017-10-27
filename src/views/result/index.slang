div.row
  div.col-sm-11
    h2 Results
  div.col-sm-1
    a.btn.btn-success.btn-xs href="/results/new" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Is_up
        th Check
        th Actions
    tbody
    - results.each do |result|
      tr
        td = result.is_up
        td = result.check.id
        td
          span
            a.btn.btn-primary.btn-xs href="/results/#{ result.id }" read
            a.btn.btn-success.btn-xs href="/results/#{ result.id }/edit" edit
            a.btn.btn-danger.btn-xs href="/results/#{ result.id }?_method=delete" onclick="return confirm('Are you sure?');" delete

