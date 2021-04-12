class Domains::Delete < BrowserAction
  delete "/domain/:id" do
    domain = DomainQuery.new.find(id)

    authorize domain

    domain.delete
    redirect Domains::Index
  end
end
