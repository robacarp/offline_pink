class Shared::NavBar < BaseComponent
  needs current_user : User?
  needs admin_user : User?

  def render
    header do
      link to: Home::Index, class: "flex items-center flex-shrink-0 mr-6 py-4 text-white font-semibold text-xl tracking-tight" do
        text "Offline."
        span "pink", class: "hover:italic"
      end

      label class: "hamburger", for: "hamburger-menu-toggle" do
        tag "svg", class: "fill-current h-3 w-3", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
          title "Menu"
          tag "path", d: "M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"
        end
      end

      input type: "checkbox", id: "hamburger-menu-toggle", class: "hidden"

      nav class: "hidden w-full border-t border-slate-200 md:w-auto md:block md:border-0" do
        div class: "relative w-auto flex flex-col text-center md:flex md:flex-row md:justify-between md:items-center" do
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
    menu_item "Monitored Domains", to: My::Domains::Index if feature_enabled?(:domain_monitoring)
    menu_item "Account", to: My::Account::Show

    if admin_user
      label class: "admin-burger", for: "admin-menu-toggle" do
        text "Admin"
      end

      admin_menu
    end
  end

  def logged_out_menu
    menu_item "Sign In", to: SignIns::New
  end

  def admin_menu
    input type: "checkbox", id: "admin-menu-toggle", class: "hidden"
    nav class: "hidden w-full border-t border-slate-200 md:w-auto md:border-0 md:absolute md:top-12" do
      div class: "z-10 bg-gray-500 flex flex-col md:flex-row" do
        menu_item "Features", to: Admin::Features::Index
        menu_item "Users", to: Admin::Users::Index
      end
    end
  end

  private def menu_item(text, to action)
    link text, to: action, class: "p-4 inline-block md:p-2"
  end
end
