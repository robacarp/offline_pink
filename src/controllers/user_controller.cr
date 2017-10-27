class UserController < ApplicationController
  def index
    users = User.all
    render "index.slang"
  end

  def show
    if user = User.find params["id"]
      render "show.slang"
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to "/users"
    end
  end

  def new
    user = User.new
    password = ""
    render "new.slang"
  end

  def create
    password = params["password"]
    user = User.new params.to_h.select(["email"])

    user.save_password params["password"]

    if user.valid? && user.save
      flash["success"] = "Created User successfully."
      redirect_to "/users"
    else
      flash["danger"] = "Could not create User!"
      render "new.slang"
    end
  end

  def edit
    password = ""
    user = User.find params["id"]

    unless user
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to "/users"
      return
    end

    render "edit.slang"
  end

  def update
    user = User.find(params["id"])

    unless user
      flash["warning"] = "User with ID #{params["id"]} Not Found"
      redirect_to "/users"
      return
    end

    password = params["password"]
    user.set_attributes params.to_h.select(["name", "email", "crypted_password"])

    if params["password"]
      user.save_password params["password"]
    end

    if user.valid? && user.save
      flash["success"] = "Updated User successfully."
      redirect_to "/users"
    else
      flash["danger"] = "Could not update User!"
      render "edit.slang"
    end
  end

  def destroy
    if user = User.find params["id"]
      user.destroy
    else
      flash["warning"] = "User with ID #{params["id"]} Not Found"
    end
    redirect_to "/users"
  end
end
