class SchedulerJob < Mosquito::PeriodicJob
  run_every 1.minute

  def perform
    DomainQuery.new.is_valid(true).each do |domain|
      MonitorJob.new(domain_id: domain.id).enqueue
    end

    DomainQuery.new.verification_status(Domain::Verification::Pending).each do |domain|
      DomainVerificationJob.new(domain_id: domain.id).enqueue
    end
  end
end
