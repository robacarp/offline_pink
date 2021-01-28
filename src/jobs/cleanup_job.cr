class CleanupJob < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    purge_date = 5.hours.ago
    # todo log the count of logs/metrics being deleted
    LogEntryQuery.new.created_at.lt(purge_date).delete
    MetricQuery.new.created_at.lt(purge_date).delete
  end
end
