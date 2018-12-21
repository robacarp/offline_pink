abstract class GuestLayout < Layout
  def user_menu
    li class: "nav-item" do
      link to: Session::New, class: "nav-link" do
        text "Log in"
      end
    end
  end
end
