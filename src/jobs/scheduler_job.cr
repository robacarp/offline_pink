class SchedulerJob < Mosquito::PeriodicJob
  run_every 1.minute

  def perform
    DomainQuery.new.is_valid(true).each do |domain|
      MonitorJob.new(domain_id: domain.id).enqueue
    end
  end
end
