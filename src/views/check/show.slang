p = check.type
p = check.reference
p
  a.btn.btn-default.btn-xs href="/checks" back
  a.btn.btn-success.btn-xs href="/checks/#{ check.id }/edit" edit
  a.btn.btn-danger.btn-xs href="/checks/#{ check.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
