class Domains::ShowPage < MainLayout
  needs domain : Domain

  def content
    div ".row" do
      div ".col-md-4.offset-md-3" do
        h1 @domain.name
      end

      div ".col-md-4" do
      end
    end

    div ".row" do
      div ".col-md-8.offset-md-2" do
        table class: "table table-dark" do
        end
      end
    end
  end
end
