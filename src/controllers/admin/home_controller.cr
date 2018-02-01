class Admin::HomeController < Admin::Controller
  def show
    user_count = User.where(email: "robert@robacarp.com").count
    domain_count = Domain.count
    route_count = Route.count
    render "show.slang"
  end
end
