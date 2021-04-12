class Monitor::Icmp::Create < BrowserAction
  post "/domain/:id/monitors/icmp/create" do
    domain = DomainQuery.new.find(id)
    authorize domain, DomainPolicy, :update?

    SaveIcmpMonitor.create domain: domain do |operation, monitor|
      if monitor
        flash.keep
        flash.success = "Now monitoring #{domain.name} with ICMP"
        redirect Domains::Show.route(id: domain)

      else
        flash.failure = "Could not create monitor : #{operation.errors}"
        html Monitor::NewPage,
            domain: domain,
            icmp_op: operation,
            http_op: SaveHttpMonitor.new(domain: domain),
            selected_monitor: :icmp
      end
    end
  end
end
