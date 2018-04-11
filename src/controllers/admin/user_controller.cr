class Admin::UserController < Admin::Controller
  def admin_path
    "/admin"
  end

  def admin_user_path(user : User)
    "/admin/user/#{user.id}"
  end

  def admin_users_path
    "/admin/users"
  end

  def activate_path(user : User)
    "/admin/user/#{user.id}/activate"
  end

  def deactivate_path(user : User)
    "/admin/user/#{user.id}/deactivate"
  end

  def index
    users = User.where().order(id: :asc).first(20)
    user_count = User.count
    admin_count = User.where(admin: true).count
    render "index.slang"
  end

  def show
    unless user = User.find(params["id"])
      flash["warning"] = "User doesn't exist"
      redirect_to admin_path
      return
    end

    domains = user.domains
    render "show.slang"
  end

  def activate
    unless user = User.find params["id"]
      flash["warning"] = "User doesn't exist"
      redirect_to admin_path
      return
    end

    user.activated = true
    if user.save
      flash["success"] = "User activated."
      redirect_to admin_user_path(user)
    end
  end

  def deactivate
    unless user = User.find params["id"]
      flash["warning"] = "User doesn't exist"
      redirect_to admin_path
      return
    end

    user.activated = false
    if user.save
      flash["success"] = "User deactivated."
      redirect_to admin_user_path(user)
    end
  end
end
