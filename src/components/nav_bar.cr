class Shared::NavBar < BaseComponent
  needs current_user : User?
  needs admin_user : User?

  def render
    header class: "relative flex flex-wrap items-center justify-between pb-3" do
      link to: Home::Index, class: "flex items-center flex-shrink-0 text-white font-semibold text-xl tracking-tight" do
        text "Offline."
        span "pink", class: "hover:italic"
      end

      label class: "md:hidden", for: "main-menu-toggle" do
        tag "svg", class: "fill-current h-3 w-3", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
          title "Menu"
          tag "path", d: "M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"
        end
      end

      input type: "checkbox", class: "menu-toggle hidden", id: "main-menu-toggle"

      nav class: "show-in-md w-full border-t border-slate-200 md:w-auto md:block md:border-0" do
        div class: "relative w-auto flex flex-col pt-2 space-y-2 text-center
                    md:flex-row md:justify-between md:items-center md:space-y-0 md:space-x-4" do
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
      label for: "admin-menu-toggle" do
        text "Admin"
      end

      admin_menu
    end
  end

  def logged_out_menu
    menu_item "Sign In", to: SignIns::New
  end

  def admin_menu
    input type: "checkbox", id: "admin-menu-toggle", class: "menu-toggle hidden"
    nav class: "w-full border-t border-slate-200 bg-gray-500 md:w-auto md:border-0 md:absolute md:top-0 md:p-4" do
      div class: "z-10 flex flex-col space-y-2
                  md:flex-row md:space-y-0 md:space-x-4" do
        menu_item "Features", to: Admin::Features::Index
        menu_item "Users", to: Admin::Users::Index
      end
    end
  end

  private def menu_item(text, to action)
    link text, to: action, class: "inline-block"
  end
end
