class Monitors::ICMP < BaseModel
  table :icmp_monitors do
    belongs_to domain : Domain
  end
end
