class Monitors::ICMP < BaseMonitor
  table :icmp_monitors do
    belongs_to domain : Domain
    belongs_to region : Region
  end

  def type
    "ICMP"
  end
end
