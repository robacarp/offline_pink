abstract class MainLayout < Layout
  needs current_user : User

  def user_menu
    li class: "nav-item dropdown" do
      a "Settings", class: "nav-link dropdown-toggle", href: "#", role: "button", "data-toggle": "dropdown"

      div ".dropdown-menu" do
        a "Account", class: "dropdown-item", href: "/account"

        # if current_user.can? :use_pushover
        a "Pushover", class: "dropdown-item", href: "/pushover_settings"
      end
    end

    li class: "nav-item" do
      link "Log out", to: Session::Delete, class: "nav-link"
    end
  end

end
