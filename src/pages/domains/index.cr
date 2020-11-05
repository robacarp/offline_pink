class Domains::IndexPage < AuthLayout
  needs domains : Array(Domain)

  def content
    div class: "row" do
      div class: "col-md-4 offset-md-3" do
        h1 "Monitored Domains"
      end

      div class: "col-md-2" do
        link "Monitor a new domain", to: Domains::New
      end
    end

    div class: "row" do
      div class: "col-md-6 offset-md-3" do
        table class: "table table-dark" do
          @domains.each do |domain|
            tr do
              td do
                link domain.name, to: Domains::Show.with(id: domain.id)
              end
            end
          end
        end
      end
    end

  end
end
