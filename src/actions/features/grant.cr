class Features::Grant < AdminAction
  post "/features/:id/grant" do
    feature = FeatureQuery.new
      .preload_grants(EnabledFeatureQuery.new.preload_user)
      .find(id)

    user_id = params.nested(:enabled_feature)["user_id"]
    user = UserQuery.new.find(id)

    GrantFeature.create(params, feature) do |operation, feature_grant|
      if feature_grant
        flash.info = "Access to #{feature.name} granted to #{user.email}"
        redirect to: Features::Index
      else
        html ShowPage, create_op: operation, feature: feature
      end
    end
  end
end
