class Monitor::Icmp
  include JSON::Serializable
  include JsonHelpers

  def string_config : String
    ""
  end

  def summary : String
    "icmp"
  end
end
