class SchedulerJob < Mosquito::PeriodicJob
  run_every 1.minute

  def perform
    u = User.first
    return unless u

    Domain.find_each do |domain|
      PingJob.new(domain: domain).enqueue
    end
  end
end
