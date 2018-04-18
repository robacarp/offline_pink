class UserController < ApplicationController
  authorize_with UserPolicy, User

  private def user_params
    params_hash.select [
      "email"
    ]
  end

  def show
    if user = User.find params["id"]
      authorize user
      render "show.slang"
    else
      flash["warning"] = "User not found."
      redirect_to users_path
    end
  end

  def new
    user = User.new
    authorize user

    invite_code = params["invite"]?
    invite = Invite.where(code: invite_code).first

    if invite
      session[:invite_code] = invite_code
    end

    render "new.slang"
  end

  def create
    user = User.new user_params
    authorize user

    unless params["password"].blank?
      user.hash_password params["password"]
    end

    if invite = Invite.where(code: session[:invite_code]).first
      if invite.use!
        user.invite_id = invite.id
        user.activated = true
      else
        flash["warning"] = "The invite code used is no longer valid."
      end

      session.delete :invite_code
    end

    if user.valid? && user.save
      UserSignupMailer.new(user).deliver
      flash["success"] = "Successfully registered and logged in."
      login_user user
      redirect_to root_path
    else
      flash["danger"] = "Registration unsuccessful, check for errors and retry."
      render "new.slang"
    end
  end

  def edit
    user = User.find params["id"]

    authorize user

    unless user
      flash["warning"] = "User not found."
      redirect_to users_path
      return
    end

    render "edit.slang"
  end

  def update
    user = User.find(params["id"])

    authorize user

    unless user
      flash["warning"] = "User not found."
      redirect_to users_path
      return
    end

    user.set_attributes user_params

    if password = params["password"]
      user.hash_password params["password"]
    end

    if user.valid? && user.save
      flash["success"] = "Updated successfully."
      redirect_to users_path
    else
      flash["danger"] = "Could not update!"
      render "edit.slang"
    end
  end
end
