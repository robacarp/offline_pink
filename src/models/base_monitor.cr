module Monitor
  alias Any = Monitor::Http | Monitor::Icmp

  abstract class Base < BaseModel
    abstract def type
    abstract def id
    abstract def string_config : String

    def region
    end

    def summary
      "#{type} #{string_config}"
    end
  end
end
