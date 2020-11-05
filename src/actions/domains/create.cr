class Domains::Create < BrowserAction
  post "/my/domains/new" do
    SaveDomain.create(params, user: current_user) do |operation, domain|
      if domain
        flash.success = "Now monitoring #{domain.name}"
        redirect Home::Index
      else
        flash.failure = "Could not create domain"
        html NewPage, save: operation
      end
    end
  end
end
