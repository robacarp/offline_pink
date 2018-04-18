module UrlHelpers
  def root_path
    if current_user.guest? || ! current_user.activated?
      "/"
    else
      domains_path
    end
  end






  def users_path
    "/users"
  end

  def user_path(user : User)
    "/user/#{user.id}"
  end

  def new_user_path
    "/user"
  end

  def invited_user_registration_path(invite : Invite)
    "/me/register?invite=#{invite.code}"
  end

  def user_activation_path
    "/me/activate"
  end






  def domains_path
    "/my/domains"
  end

  def new_domain_path
    "#{domains_path}/new"
  end

  def domain_path(domain : Domain)
    "/domain/#{domain.id}"
  end

  def delete_domain_path(domain : Domain)
    "#{domain_path domain}/delete"
  end

  def revalidate_domain_path(domain : Domain)
    "#{domain_path domain}/revalidate"
  end

  def domain_monitors_path(domain : Domain)
    "#{domain_path domain}/monitors"
  end

  def new_domain_monitor_path(domain : Domain)
    "#{domain_monitors_path domain}/new"
  end


  def monitor_path(monitor : Monitor)
    "/monitor/#{monitor.id}"
  end

  def delete_monitor_path(monitor : Monitor)
    "#{monitor_path monitor}/delete"
  end






  def new_session_path
    "/sessions/new"
  end

  def destroy_session_path
    "/sessions/destroy"
  end








  def new_admin_invite_path
    "/admin/invites/new"
  end

  def admin_invites_path
    "/admin/invites"
  end

  def admin_invite_path(invite : Invite, **query_params)
    query_string = query_params.map do |name, value|
      "#{name}=#{value}"
    end.join("&")

    String.build do |path|
      path << "/admin/invite/"
      path << invite.id

      if query_string.size > 0
        path << "?"
        path << query_string
      end
    end
  end

  def admin_users_path
    "/admin/users"
  end

  def admin_user_path(user : User)
    "/admin/user/#{user.id}"
  end

  def admin_path
    "/admin"
  end

  def admin_activate_user_path(user : User)
    "/admin/user/#{user.id}/activate"
  end

  def admin_deactivate_user_path(user : User)
    "/admin/user/#{user.id}/deactivate"
  end

end
