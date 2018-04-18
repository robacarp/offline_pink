class UserController < ApplicationController
  authorize_with UserPolicy, User

  private def user_params
    params_hash.select [
      "email"
    ]
  end



  def root_path
    "/"
  end

  def users_path
    "/users"
  end

  def user_path(user : User)
    "/user/#{user.id}"
  end

  def invite_needed_path
    "/me/register/invite_needed"
  end


  def show
    if user = User.find params["id"]
      authorize user
      render "show.slang"
    else
      flash["warning"] = "User not found."
      redirect_to "/users"
    end
  end

  def new
    user = User.new
    authorize user
    render "new.slang"
  end

  def create
    user = User.new user_params

    unless params["password"].blank?
      user.hash_password params["password"]
    end

    authorize user

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
