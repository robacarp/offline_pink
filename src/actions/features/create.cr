class Features::Create < AdminAction
  post "/features/new" do
    SaveFeature.create(params) do |operation, feature|
      if feature
        flash.success = "Added feature #{feature.name}"
        redirect Features::Show.with(feature)
      else
        flash.failure = "Could not create feature flag"
        html NewPage, save: operation
      end
    end
  end
end
