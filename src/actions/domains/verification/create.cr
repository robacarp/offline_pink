class Domains::Verification::Create < BrowserAction
  ensure_feature_permitted :domain_monitoring

  post "/domains/:id/verification" do
    domain = DomainQuery.new.find(id)
    authorize domain, DomainPolicy, :edit?

    DomainOp::UpdateVerification.update(domain, verification_status: Domain::Verification::Pending) do |operation, domain|
      if operation.saved?
        redirect to: Domains::Verification::Show.with(domain)
      else
        flash.failure = "Domain verification failed :("
        redirect to: Domains::Verification::Show.with(domain)
      end
    end
  end
end
