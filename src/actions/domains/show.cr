class Domains::Show < BrowserAction
  get "/domains/:id" do
    render ShowPage, domain: DomainQuery.new.find(id)
  end
end
