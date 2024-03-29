class MonitorHttp::Create < BrowserAction
  post "/domain/:id/monitors/http/create" do
    domain = DomainQuery.new.find(id)
    authorize domain, DomainPolicy, :update?

    SaveHttpMonitor.create(params, domain) do |operation, monitor|
      if monitor
        flash.keep
        flash.success = "Now monitoring #{domain.name} with HTTP"
        redirect Domains::Show.route(id: domain)

      else
        flash.failure = "Could not create monitor : #{operation.errors}"
        html Monitor::NewPage,
            domain: domain,
            icmp_op: SaveIcmpMonitor.new(domain: domain),
            http_op: operation,
            selected_monitor: :http
      end
    end
  end
end
