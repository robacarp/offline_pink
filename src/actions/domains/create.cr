class Domains::Create < BrowserAction
  post "/my/domains/new" do
    owner = decode_owner params.nested(:domain)["owner"]

    user_id = nil
    organization_id = nil

    case
    when owner.holds? User
      user_id = owner.id
    when owner.holds? Organization
      organization_id = owner.id
    end

    SaveDomain.create(params, user_id: user_id, organization_id: organization_id) do |operation, domain|
      if domain
        flash.success = "Now monitoring #{domain.name}"
        redirect Domains::Index
      else
        flash.failure = "Could not create domain"
        html NewPage, save: operation
      end
    end
  end
end
