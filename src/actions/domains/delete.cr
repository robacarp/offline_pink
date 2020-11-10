class Domains::Delete < BrowserAction
  delete "/domain/:id" do
    d = DomainQuery.new
      .user_id(current_user.id)
      .find(id)

    d.delete

    redirect Domains::Index
  end
end
