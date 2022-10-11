class SchedulerJob < Mosquito::PeriodicJob
  run_every 1.minute

  def perform
    domain_ids = [] of Int64

    # Domains which have never been checked.
    DomainQuery.new
      .last_monitor_event.is_nil
      .each do |domain|
        domain_ids << domain.id
      end

    # All domains which are:
    # - valid,
    # - verified, and
    # - haven't been checked in the last minute.
    DomainQuery.new
      .is_valid(true)
      .verification_status(Domain::Verification::Verified)
      .last_monitor_event.lte(1.minute.ago)
      .each do |domain|
        domain_ids << domain.id
      end

    # Domains which are:
    # - valid,
    # - not necessarily verified, and
    # - haven't been checked in the last 10 minutes.
    DomainQuery.new
      .is_valid(true)
      .last_monitor_event.lte(10.minutes.ago)
      .each do |domain|
        domain_ids << domain.id
      end

    # Enqueue a job for each domain which qualified above for a monitor event.
    domain_ids.uniq.each do |domain_id|
      MonitorJob.new(domain_id: domain_id).enqueue
    end

    # Enqueue a job for each domain which needs to be verified.
    DomainQuery.new.verification_status(Domain::Verification::Pending).each do |domain|
      DomainVerificationJob.new(domain_id: domain.id).enqueue
    end

    # For domains which have not been verified, if it's been waiting more than 24 hours try again
    DomainQuery.new
      .verification_status(Domain::Verification::Failed)
      .verified_at.lte(1.days.ago)
      .each do |domain|
        DomainVerificationJob.new(domain_id: domain.id).enqueue
      end

    # Search for domains which have been verified for at least 90 days and re-verify them.
    DomainQuery.new
      .verification_status(Domain::Verification::Verified)
      .verified_at.lte(90.days.ago)
      .each do |domain|
        DomainVerificationJob.new(domain_id: domain.id).enqueue
      end
  end
end
