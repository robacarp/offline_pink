class Admin::Users::Impersonate < AdminAction
  post "/users/assume/:id" do
    viewer = UserQuery.new.find(id)
    admin_takeover viewer
    flash.success = "Viewing as #{viewer.email}"
    redirect to: Home::Index
  end
end
