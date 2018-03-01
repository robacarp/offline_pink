module IcmpMonitor
  def validate_icmp
    duplicate_monitors = Monitor.where(domain_id: @domain_id, monitor_type: Monitor::VALID_TYPES[:ping])
    (add_error :monitor, Monitor::MESSAGES[:duplicate]; return) if duplicate_monitors.any?
  end
end
