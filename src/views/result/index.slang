div.row
  div.col-sm-11
    h2 Results
  div.col-sm-1
    a.btn.btn-success.btn-xs href="/results/new" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Check
        th Up?
        th Response Time
    tbody
    - results.each do |result|
      tr
        td = result.check.host
        td = result.is_up
        td = result.response_time

