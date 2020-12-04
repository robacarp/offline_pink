module Monitoring
  class Result
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
  end
end
