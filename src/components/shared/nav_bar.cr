class Shared::NavBar < BaseComponent
  needs current_user : User?
  needs admin_user : User?

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
      nav id: "nav" do
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
    link "Monitored Domains", to: My::Domains::Index if feature_enabled?(:domain_monitoring)
    link "Account", to: My::Account::Show

    if admin_user
      label class: "admin-burger", for: "admin-menu-toggle" do
        text "Admin"
      end

      admin_menu
    end
  end

  def logged_out_menu
    link "Sign In", to: SignIns::New
  end

  def admin_menu
    input type: "checkbox", id: "admin-menu-toggle"
    nav id: "admin-menu" do
      div class: "items" do
        link "Features", to: Admin::Features::Index
        link "Users", to: Admin::Users::Index
      end
    end
  end
end
