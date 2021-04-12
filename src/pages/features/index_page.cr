class Features::IndexPage < AuthLayout
  needs features : FeatureQuery

  def content
    small_frame do
      header_and_links do
        h1 "Site Features"
      end

      table class: "mx-auto w-64 table-zebra table-borders" do
        tr do
          th "Feature"
          th "Status"
        end

        @features.each { |feature| feature_row(feature) }
      end
    end
  end

  def feature_row(feature : ::Feature)
    tr do
      td do
        link feature.name, to: Features::Show.with(feature)
      end

      td do
        text feature.state.to_s

        unless feature.editable?
          nbsp
          text "(not editable)"
        end
      end
    end
  end
end
