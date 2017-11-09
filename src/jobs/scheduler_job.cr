class SchedulerJob < Mosquito::PeriodicJob
  run_every 1.minute

  def perform
    u = User.first
    return unless u

    Check.find_each do |check|
      if check.ping_check?
        PingJob.new(check: check).enqueue
      end

      if check.get_request?
        GetJob.new(check: check).enqueue
      end
    end
  end
end
