class Monitor::CreateIcmp < BrowserAction
  post "/domain/:domain_id/monitors/create/icmp" do
    domain = DomainQuery.new.find domain_id

    Monitor::Icmp::Save.create domain: domain do |operation, monitor|
      if monitor
        flash.success = "Now monitoring #{domain.name} with ICMP"
        redirect Domains::Show.route(id: domain)
      else
        flash.failure = "Could not create monitor : #{operation.errors}"
        redirect Home::Index
      end
    end
  end
end