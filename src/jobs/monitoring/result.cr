module Monitoring
  class Result
    getter log : Array(String)
    getter host : Host
    getter success : Bool?

    def initialize(@host : Host)
      @log = [] of String
    end

    protected def successful!
      @success = true
    end

    protected def failed!
      @success = false
    end

    def log(message : String)
      @log << "#{host.ip_address} - #{message}"
    end

  end
end