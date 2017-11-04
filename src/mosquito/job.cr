require "./logger"

module Mosquito
  abstract class Job
    include Logger

    def puts(message : String)
      log "[#{self.class.name}] #{message}"
    end

    getter executed = false
    getter succeeded = false

    def self.job_type : String
      ""
    end

    def self.queue
      if job_type.blank?
        Queue.new("default")
      else
        Queue.new(job_type)
      end
    end

    def run
      raise DoubleRun.new if executed
      @executed = true
      perform
      @succeeded = true
    rescue JobFailed
      @succeeded = false
    end

    def perform
      puts "No job definition found for #{self.class.name}"
      fail
    end

    def fail
      raise JobFailed.new
    end

    def executed?
      @executed
    end

    def succeeded?
      raise "Job hasn't been executed yet" unless @executed
      @succeeded
    end

    def failed?
      ! succeeded?
    end
  end

  class JobFailed < Exception
  end

  class DoubleRun < Exception
  end
end
