class Admin::Users::Show < AdminAction
  get "/users/:id" do
    user = UserQuery.new
      .preload_domains
      .preload_enabled_features(
        Featurette::EnabledFeatureQuery.new.preload_feature
      )
      .find(id)

    html ShowPage, user: user
  end
end
