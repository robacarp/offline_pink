class Admin::Users::Index < AdminAction
  get "/users" do
    users = UserQuery.new
    html IndexPage, users: users
  end
end
