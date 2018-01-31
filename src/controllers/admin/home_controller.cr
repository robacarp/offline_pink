class Admin::HomeController < Admin::Controller
  def show
    user_count = User.where(email: "robert@robacarp.com").count
    render "show.slang"
  end
end
