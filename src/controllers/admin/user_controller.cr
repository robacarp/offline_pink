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

  def features
    unless user = User.find params["id"]
      flash["warning"] = "User doesn't exist"
      redirect_to admin_users_path
      return
    end

    user.set_features params.fetch_all "feature"

    if user.id == current_user.id && ! user.can? :admin
      flash["info"] = "You cannot remove the Admin feature from yourself."
      user.enable :admin
    end

    if user.save
      flash["success"] = "User features updated."
    else
      flash["danger"] = "User features didn't update."
    end

    redirect_to admin_user_path(user)
  end
end
