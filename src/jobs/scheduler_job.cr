class SchedulerJob < Mosquito::Job
  def perform
    puts "Scheduler Job"
    fail
  end
end
