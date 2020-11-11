module Monitor
  alias Any = Monitor::HTTP | Monitor::ICMP

  abstract class Base < BaseModel
    abstract def type
    abstract def id

    def region

    end
  end
end
