class Admin::Features::Toggle < AdminAction
  post "/features/:id" do
    feature = Featurette::FeatureQuery.new.find(id)

    ToggleFeature.update(feature, params) do |operation, feature|
      if operation.saved?
        flash.info = "Feature #{tensify(feature.state)}"
        redirect to: Features::Show.with(feature)
      else
        html(
          ShowPage,
          feature: feature,
          grant_op: GrantFeature.new(feature),
          toggle_op: operation
        )
      end
    end
  end

  def tensify(state)
    case state
    when .disabled?
      "disabled"
    when .enabled?
      "enabled"
    when .grantable?
      "enabled per-user"
    else
      pp state
      ""
    end
  end
end
