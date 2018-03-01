class Admin::HomeController < Admin::Controller
  def show
    user_count = User.count
    domain_count = Domain.count
    monitor_count = Monitor.count
    render "show.slang"
  end
end
