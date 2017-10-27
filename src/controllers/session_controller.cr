class SessionController < ApplicationController
  def new
    email = "robert@robacarp.com"
    password = "12345"
    render "new.slang"
  end

  def create
    user = User.find_by :email, params["email"]

    if user && user.check_password params["password"]
      login_user user
      flash["success"] = "Logged in"
      redirect_to "/"
    else
      flash["warning"] = "Email or password invalid"
      redirect_to "/sessions/new"
    end
  end

  def destroy
    logout
    flash["info"] = "Logged out"
    redirect_to "/"
  end
end
