class Monitors::ICMP::Create < BrowserAction
  require_logged_in!

  post "/domain/:domain_id/monitors/create/icmp" do
    domain = DomainQuery.new.find domain_id

    Monitors::ICMP::BaseForm.create(domain_id: domain.id) do |form, monitor|
      if monitor
        flash.success = "Now monitoring #{domain.name} with ICMP"
        redirect Domains::Show.route(id: domain)
      else
        flash.failure = "Could not create monitor : #{form.errors}"
        redirect Home::Index
      end
    end
  end
end
