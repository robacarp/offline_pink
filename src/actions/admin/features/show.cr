class Admin::Features::Show < AdminAction
  get "/features/:id" do
    feature = FeatureQuery.new
      .preload_grants(EnabledFeatureQuery.new.preload_user)
      .find(id)

    authorize feature, FeaturePolicy

    html(
      ShowPage,
      feature: feature,
      grant_op: GrantFeature.new(feature),
      toggle_op: ToggleFeature.new(feature)
    )
  end
end
