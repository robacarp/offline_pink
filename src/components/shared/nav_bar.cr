class Shared::NavBar < BaseComponent
  def render
    header do
      div class: "logo" do
        text "Offline."
        span "pink", class: "pink"
      end

      label class: "hamburger", for: "hamburger-menu-toggle" do
        tag "svg", class: "fill-current h-3 w-3", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
          title "Menu"
          tag "path", d: "M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"
        end
      end

      input type: "checkbox", id: "hamburger-menu-toggle"
      nav do
        div class: "items" do
          link "Monitored Domains", to: Domains::Index
          link "Account", to: My::Account::Show
        end
      end
    end
  end
end
