class Domains::IndexPage < AuthLayout
  needs domains : DomainQuery

  def content
    small_frame do
      header_and_links do
        h1 "Monitored Domains"
        link "Monitor a new domain", to: Domains::New
      end

      table class: "mx-auto w-64 table-zebra table-borders" do
        tr do
          th "DNS Name"
          th "Status"
        end

        @domains.each { |domain| domain_row for: domain }
      end
    end
  end

  def domain_row(for domain : Domain)
    tr do
      td do
        link to: Domains::Show.with(id: domain.id) do
          text domain.name
        end
      end

      td domain.status_code.to_s
    end
  end
end
