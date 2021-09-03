class SaveIcmpMonitor < Monitor::SaveOperation
  include SaveMonitor

  before_save do
    config.value = Monitor::Icmp.from_json("{}").to_any
    domain_id.value = domain.id
    region_id.value = Region.default_region.id
  end

  def type
    Monitor::Type::Icmp
  end

  def monitor_config
    Monitor::Icmp.from_json("{}").to_any
  end

  def ensure_uniqueness_of_monitor
    permit_only_one_monitor_per_domain
  end

  def permit_only_one_monitor_per_domain
    return unless domain_fk = domain.id

    results = MonitorQuery.new
      .domain_id(domain_fk)
      .monitor_type(type.to_i)
      .first?

    if results
      # this won't ever show, but is needed to fail the validations
      domain_id.add_error "is already being checked"
      @meta_error = "Only one ICMP monitor can be present for a domain"
    end
  end
end
