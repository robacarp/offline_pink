class Features::ShowPage < AuthLayout
  needs feature : ::Feature
  needs grant_op : GrantFeature
  needs toggle_op : ToggleFeature

  def content
    small_frame do
      header_and_links do
        h1 do
          text feature.name
          middot_sep
          text feature.state.to_s.downcase
        end
      end

      h3 "Enable or Disable"
      form_for Features::Toggle.with(feature) do
        div class: "field" do
          select_input(toggle_op.state) do
            # options_for_select doesn't work well with enum
            Feature.states_for_select.each do |option_name, option_value|
              attributes = {"value" => option_value.to_s}

              is_selected = option_value == feature.state.to_i
              attributes["selected"] = "true" if is_selected

              option(option_name, attributes)
            end
          end
        end

        submit "Update"
      end

      if feature.state.to_i == Feature::State::Grantable.to_i
        unless feature.grants.empty?
            table do
              tr do
                th "Entity"
                th "Granted On"
              end

              feature.grants.each do |grant|
                tr do
                  td do
                    text grant.user.email
                  end

                  td do
                    text grant.created_at.to_rfc3339
                  end
                end
              end
          end

          hr
        end

        h3 "Grant a user this feature"
        form_for Features::Grant.with(grant_op.feature) do
          mount Shared::Field, attribute: grant_op.user_id, label_text: "User ID", &.number_input

          submit "Grant"
        end
      end
    end
  end
end
