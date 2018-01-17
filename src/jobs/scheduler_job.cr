class SchedulerJob < Mosquito::PeriodicJob
  run_every 1.minute

  def perform
    u = User.first
    return unless u

    Domain.find_each do |domain|
      PingJob.new(domain: domain).enqueue

      domain.routes.each do |route|
        GetJob.new(route: route).enqueue
      end
    end
  end
end
