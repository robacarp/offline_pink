module Monitor
  alias Any = Monitor::Http | Monitor::Icmp

  abstract class Base < BaseModel
    abstract def type
    abstract def id

    def region

    end
  end
end
