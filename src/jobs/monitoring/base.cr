module Monitoring
  abstract class Base
    getter result : Result
    getter host : Host

    private getter monitor : Monitor::Any

    def self.check(hosts : Array(Host), with monitor : Monitor::Any) : Array(Result)
      hosts.map do |host|
        check host, with: monitor
      end
    end

    def self.check(host : Host, with monitor : Monitor::Any) : Result
      instance = new(host, monitor)
      instance.check
      instance.result
    end

    def initialize(@host : Host, @monitor : Monitor::Any)
      @result = Result.new host
    end

    delegate :successful!, :failed!, to: @result

    def log(message : String)
      result.log "#{self.class.log_identifier} - #{message}"
    end

    protected abstract def check : Nil

    def self.log_identifier : String
      ""
    end
  end
end

