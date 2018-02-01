class Admin::UserController < Admin::Controller
  def index
    users = User.first(20)
    user_count = User.count
    admin_count = User.where(admin: true).count
    render "index.slang"
  end

  def show
    unless user = User.find(params["id"])
      flash["warning"] = "No user with that ID"
      redirect_to "/admin"
      return
    end

    domains = user.domains
    render "show.slang"
  end
end
