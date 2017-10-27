p = result.is_up
p = result.check.id
p
  a.btn.btn-default.btn-xs href="/results" back
  a.btn.btn-success.btn-xs href="/results/#{ result.id }/edit" edit
  a.btn.btn-danger.btn-xs href="/results/#{ result.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
