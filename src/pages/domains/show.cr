class Domains::ShowPage < AuthLayout
  needs domain : Domain

  def content
    fixed_width do
      h1 do
        text "Monitoring "
        text domain.name
      end

      link "Stop Monitoring", to: Domains::Delete.with(domain), data_confirm: "Are you sure?"

      hr

      table do
        domain.monitors.each do |monitor|
          tr do
            td monitor.id
            td monitor.type
          end
        end
      end

    end
  end
end
