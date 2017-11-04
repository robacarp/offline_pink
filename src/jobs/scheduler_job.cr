 class SchedulerJob < Mosquito::PeriodicJob
  run_every 1.minute

  def perform
    puts "I AM RUNNING"
  end
end
