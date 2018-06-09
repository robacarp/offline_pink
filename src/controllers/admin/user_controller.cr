class Admin::UserController < Admin::Controller
  def index
    users = User.where().order(id: :asc).first(20)
    user_count = User.count
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
      redirect_to admin_users_path
      return
    end

    user.enable! :active

    if user.save
      flash["success"] = "User activated."
      redirect_to admin_user_path(user)
    end
  end

  def deactivate
    unless user = User.find params["id"]
      flash["warning"] = "User doesn't exist"
      redirect_to admin_users_path
      return
    end

    user.disable! :active

    if user.save
      flash["success"] = "User deactivated."
      redirect_to admin_user_path(user)
    end
  end
end
