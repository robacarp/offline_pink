class UserController < ApplicationController
  authorize_with UserPolicy, User

  before_action do
    only [:edit, :update] do
      unless logged_in?
        redirect_to "/"
      end
    end
  end

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
    end

    if user.valid? && user.save
      UserSignupMailer.new(user).deliver
      flash["success"] = "Successfully registered and logged in."
      session.delete :invite_code
      login_user user
      redirect_to root_path
    else
      flash["danger"] = "Registration unsuccessful, check for errors and retry."
      render "new.slang"
    end
  end

  def edit
    new_password = ""
    current_password = ""

    user = current_user
    authorize user

    unless user
      flash["warning"] = "User not found."
      redirect_to domains_path
      return
    end

    render "edit.slang"
  end

  def update
    new_password = ""
    current_password = ""

    user = current_user
    authorize user

    unless user
      flash["warning"] = "User not found."
      redirect_to domains_path
      return
    end

    # A user shouldn't need to provide a password when neither email or password have changed
    if params["password"].blank? && params["email"] == user.email
      flash["success"] = "Account updated."
      redirect_to edit_account_path
      return
    end

    user.email = params["email"]

    unless user.check_password params["current_password"]
      flash["danger"] = "Invalid password."
      return render "edit.slang"
    end

    if (password = params["password"]?) && params["password"].size != 0
      user.hash_password password
    end

    if user.valid? && user.save
      flash["success"] = "Account updated."
      redirect_to edit_account_path
    else
      flash["danger"] = "Could not update account!"
      render "edit.slang"
    end
  end
end
