class Domains::Delete < BrowserAction
  ensure_feature_permitted :domain_monitoring

  delete "/domain/:id" do
    domain = DomainQuery.new.find(id)

    authorize domain

    domain.delete
    redirect My::Domains::Index
  end
end
