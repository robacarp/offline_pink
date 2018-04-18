class SessionController < ApplicationController
  def new
    if Amber.env.development?
      email = "robert@robacarp.com"
      password = "12345"
    else
      email = ""
      password = ""
    end

    render "new.slang"
  end

  def create
    user = User.where(email: params["email"]).first

    if user && user.check_password params["password"]
      login_user user
      flash["success"] = "Logged in"
      redirect_to root_path
    else
      flash["warning"] = "Email or password invalid"
      redirect_to new_session_path
    end
  end

  def destroy
    logout
    flash["info"] = "Logged out"
    redirect_to root_path
  end
end
