class Domains::ShowPage < AuthLayout
  needs domain : Domain

  def content
    small_frame do
      header_and_links do
        h1 domain.name

        div do
          link "Stop Monitoring", to: Domains::Delete.with(domain), data_confirm: "Are you sure?"
          middot_sep
          link "Add Another Monitor", to: Monitor::Create.with(domain)
        end
      end

      table class: "mx-auto w-64 table-zebra table-borders" do
        domain.monitors.each do |monitor|
          tr do
            td monitor.type
            td monitor.summary
          end
        end
      end

    end
  end
end
