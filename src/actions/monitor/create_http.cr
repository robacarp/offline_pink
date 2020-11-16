class Monitor::Http::Create < BrowserAction
  post "/domain/:id/monitors/http/create" do
    domain = DomainQuery.new.user_id(current_user.id).find id

    Monitor::Http::Save.create(domain: domain) do |operation, monitor|
      if monitor
        flash.keep
        flash.success = "Now monitoring #{domain.name} with HTTP"
        redirect Domains::Show.route(id: domain)

      else
        flash.failure = "Could not create monitor : #{operation.errors}"
        html Monitor::NewPage,
            domain: domain,
            icmp_op: Monitor::Icmp::Save.new(domain: domain),
            http_op: operation,
            selected_monitor: :http
      end
    end
  end
end
