module Monitoring
  class Result
    getter host : Host
    getter success : Bool = false

    def initialize(@host : Host, @monitor : Monitor)
    end

    protected def successful!
      @success = true
    end

    protected def failed!
      @success = false
    end
  end
end
