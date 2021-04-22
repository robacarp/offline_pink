class Shared::NavBar < BaseComponent
  needs current_user : User?

  def render
    header do
      link to: Home::Index, class: "logo" do
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
          if current_user
            logged_in_menu 
          else
            logged_out_menu
          end
        end
      end
    end
  end

  def logged_in_menu
    link "Monitored Domains", to: Domains::Index
    link "Account", to: My::Account::Show

    if feature_enabled?(:admin)
      link "Features", to: Features::Index
    end
  end

  def logged_out_menu
    link "Login", to: SignIns::New
  end
end
