class Admin::Features::Enabled::Create < AdminAction
  post "/features/:id/grant" do
    feature = Featurette::FeatureQuery.new
      .preload_grants(Featurette::EnabledFeatureQuery.new.preload_user)
      .find(id)

    user = UserQuery.new.find(params.nested(:enabled_feature)["user_id"])

    GrantFeature.create(params, feature) do |operation, feature_grant|
      if feature_grant
        flash.info = "Access to #{feature.name} granted to #{user.email}"
        redirect to: Admin::Features::Show.with(feature)
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
