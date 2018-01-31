class UserController < ApplicationController
  authorize_with UserPolicy, User

  private def user_params
    params.to_h.select [
      "email"
    ]
  end

  def show
    if user = User.find params["id"]
      authorize user
      render "show.slang"
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
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
    user.hash_password params["password"]

    authorize user

    if user.valid? && user.save
      UserSignupMailer.new(user).deliver
      flash["success"] = "Successfully registered and logged in."
      login_user user
      redirect_to "/"
    else
      flash["danger"] = "Could not create User!"
      render "new.slang"
    end
  end

  def edit
    user = User.find params["id"]

    authorize user

    unless user
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to "/users"
      return
    end

    render "edit.slang"
  end

  def update
    user = User.find(params["id"])

    authorize user

    unless user
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to "/users"
      return
    end

    user.set_attributes user_params

    if password = params["password"]
      user.hash_password params["password"]
    end

    if user.valid? && user.save
      flash["success"] = "Updated User successfully."
      redirect_to "/users"
    else
      flash["danger"] = "Could not update User!"
      render "edit.slang"
    end
  end

  def delete
    render "delete.slang"
  end

  def destroy
    if user = User.find params["id"]
      authorize user
      user.destroy
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
    end

    redirect_to "/users"
  end
end
