class Admin::InviteController < Admin::Controller
  private def invite_params
    params_hash.select ["uses_remaining"]
  end

  def invites_path
    "/admin/invites"
  end

  def invite_path(invite : Invite, **query_params)
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

  def user_invite_path(invite : Invite)
    "/me/register?invite=#{invite.code}"
  end

  def index
    invites = Invite.all
    render "index.slang"
  end

  def show
    if invite = Invite.find params["id"]
      render "show.slang"
    else
      flash["warning"] = "Invite doesnt exist."
      redirect_to invites_path
    end
  end

  def new
    invite = Invite.new
    render "new.slang"
  end

  def create
    invite = Invite.new invite_params

    if invite.save
      flash["success"] = "Invite created."
      redirect_to invites_path
    else
      flash["danger"] = "Invite could not be created."
      render "new.slang"
    end
  end

  def destroy
    if invite = Invite.find params["id"]
      invite.destroy
      flash["success"] = "Invite deleted."
    else
      flash["warning"] = "Invite with ID #{params["id"]} Not Found"
    end

    redirect_to invites_path
  end
end
