class Organizations::ShowPage < AuthLayout
  needs organization : Organization

  def content
    small_frame do

      h1 do
        text "Organization "
        text organization.name
      end

      if (domains = organization.domains).any?
        hr
        org_domains domains
      end

      if (memberships = organization.memberships).any?
        hr
        org_memberships memberships
      end

    end
  end

  def org_memberships(memberships : Array(Membership))
    h2 "Members:"

    table do
      tr do
        th "User"
        th "Admin"
      end
      memberships.each do |membership|
        tr do
          td membership.user.email
          td do
            text "admin" if membership.admin
          end
        end
      end
    end
  end

  def org_domains(domains : Array(Domain))
    h2 "Monitoring"

    domains.each do |domain|
      link to: Domains::Show.with(id: domain.id) do
        text domain.name
      end
    end
  end

end
