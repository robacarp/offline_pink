class Features::Grant < AdminAction
  post "/features/:id/grant" do
    feature = FeatureQuery.new
      .preload_grants(EnabledFeatureQuery.new.preload_user)
      .find(id)

    user = UserQuery.new.find(params.nested(:enabled_feature)["user_id"])

    GrantFeature.create(params, feature) do |operation, feature_grant|
      if feature_grant
        flash.info = "Access to #{feature.name} granted to #{user.email}"
        redirect to: Features::Show.with(feature)
      else
        html(
          ShowPage,
          grant_op: operation,
          toggle_op: ToggleFeature.new(feature),
          feature: feature
        )
      end
    end
  end
end
