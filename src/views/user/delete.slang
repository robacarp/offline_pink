p Are you sure you want to delete your account? This cannot be undone.
== form method: "DELETE", action: "/my/destroy_account" do
  == csrf_tag
  div.form-group
    == submit "Yes, I want to permanantly destroy my account and all related data."
