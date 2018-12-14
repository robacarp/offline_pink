abstract class MainLayout < Layout
  needs current_user : User

  def render
    shell do
      render_signed_in_user
      content
    end
  end

  private def render_signed_in_user
    text @current_user.email
    text " - "
    link "Sign out", to: SignIns::Delete, flow_id: "sign-out-button"
  end
end
