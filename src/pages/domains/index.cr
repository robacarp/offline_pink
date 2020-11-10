class Domains::IndexPage < AuthLayout
  needs domains : DomainQuery

  def content
    fixed_width do
      h1 "Monitored Domains"

      link "Monitor a new domain", to: Domains::New

      list_of_domains
    end
  end

  def list_of_domains
    div class: "row" do
      div class: "col-md-6 offset-md-3" do
        table class: "table table-dark" do
          header_row

          @domains.each { |domain| domain_row for: domain }
        end
      end
    end
  end

  def header_row
    tr do
      th "DNS Name"
      th "Status"
    end
  end

  def domain_row(for domain : Domain)
    tr do
      td do
        link to: Domains::Show.with(id: domain.id) do
          text domain.name
        end
      end

      td domain.status.to_s
    end
  end
end
