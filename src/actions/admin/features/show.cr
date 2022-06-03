class Admin::Features::Show < AdminAction
  get "/features/:id" do
    feature = Featurette::FeatureQuery.new
      .preload_grants(Featurette::EnabledFeatureQuery.new.preload_user)
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
