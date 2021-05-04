class Admin::Users::Show < AdminAction
  get "/users/:id" do
    user = UserQuery.new
      .preload_domains
      .preload_features
      .find(id)
    html ShowPage, user: user
  end
end
