class Domains::Create < BrowserAction
  post "/my/domains/new" do
    DomainForm.create(params, user: current_user) do |form, domain|
      if domain
        flash.success = "Now monitoring #{domain.name}"
        redirect Home::Index
      else
        pp form.errors
        flash.failure = "Could not create domain"
        render NewPage, form: form
      end
    end
  end
end
