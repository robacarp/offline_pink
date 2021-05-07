class Admin::Features::Toggle < AdminAction
  post "/features/:id" do
    feature = FeatureQuery.new.find(id)

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
    case state.to_i
    when Feature::State::Disabled.to_i
      "disabled"
    when Feature::State::Enabled.to_i
      "enabled"
    when Feature::State::Grantable.to_i
      "enabled per-user"
    else
      pp state
      ""
    end
  end
end
