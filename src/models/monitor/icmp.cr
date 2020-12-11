class Monitor::Icmp < Monitor::Base
  policy!

  table :icmp_monitors do
    belongs_to domain : Domain
    belongs_to region : Region
  end

  def type
    "ICMP"
  end

  def string_config : String
    ""
  end

  def summary : String
    "icmp"
  end
end
