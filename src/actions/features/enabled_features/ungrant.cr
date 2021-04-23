class Features::Enabled::Destroy < AdminAction
  delete "/features/enabled/:id" do
    enabled_feature = EnabledFeatureQuery.new
      .preload_user
      .preload_feature
      .find(id)

    enabled_feature.delete

    flash.info = "#{enabled_feature.user.email} revoked from #{enabled_feature.feature.name}"

    redirect Features::Show.with(enabled_feature.feature_id)
  end
end
