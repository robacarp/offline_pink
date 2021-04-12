class Features::ShowPage < AuthLayout
  needs feature : ::Feature
  needs create_op : GrantFeature

  def content
    small_frame do
      header_and_links do
        h1 do
          text feature.name
          middot_sep
          text feature.state.to_s.downcase
        end
      end

      unless feature.grants.empty?
        shrink_to_fit do
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
        end

        hr
      end

      shrink_to_fit do
        h3 "Grant a user this feature"
        form_for Features::Grant.with(create_op.feature) do
          mount Shared::Field, attribute: create_op.user_id, label_text: "User ID", &.number_input

          shrink_to_fit do
            submit "Grant"
          end
        end
      end
    end
  end
end
