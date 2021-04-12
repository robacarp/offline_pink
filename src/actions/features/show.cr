class Features::Show < AdminAction
  get "/features/:id" do
    feature = FeatureQuery.new
      .preload_grants(EnabledFeatureQuery.new.preload_user)
      .find(id)

    authorize feature

    html ShowPage, feature: feature, create_op: GrantFeature.new(feature)
  end
end
