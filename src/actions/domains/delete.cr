class Domains::Delete < BrowserAction
  authorized_lookup Domain

  delete "/domain/:id" do
    domain.delete
    redirect Domains::Index
  end
end
