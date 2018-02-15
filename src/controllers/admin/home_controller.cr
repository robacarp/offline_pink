class Admin::HomeController < Admin::Controller
  def show
    user_count = User.count
    domain_count = Domain.count
    route_count = 0#Route.count
    render "show.slang"
  end
end
