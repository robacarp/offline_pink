module Monitoring
  abstract class Base
    getter result : Result
    getter host : Host

    private getter monitor : Monitor::Any
    private getter logger : LogArchiver
    delegate :successful!, :failed!, to: @result

    def self.check(host : Host, with monitor : Monitor::Any, logger : LogArchiver) : Result
      instance = new(host, monitor, logger)
      instance.check
      instance.result
    end

    def initialize(@host : Host, @monitor : Monitor::Any, @logger : LogArchiver)
      @result = Result.new host, monitor
    end

    def log(message : String, severity : LogEntry::Severity = LogArchiver::DEFAULT_SEVERITY)
      logger.emit "#{log_identifier} #{message}", severity, from: monitor
    end

    protected abstract def check : Nil

    def log_identifier : String
      ""
    end
  end
end

