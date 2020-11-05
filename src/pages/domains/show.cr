class Domains::ShowPage < AuthLayout
  needs domain : Domain

  def content
    div class: "row" do
      div class: "col-md-4 offset-md-3" do
        h1 @domain.name
      end

      div class: "col-md-4" do
      end
    end

    div class: "row" do
      div class: "col-md-8 offset-md-2" do
        table class: "table table-dark" do
        end
      end
    end
  end
end
