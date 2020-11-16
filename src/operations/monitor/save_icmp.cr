class Monitor::Icmp::Save < Monitor::Icmp::SaveOperation
  needs domain : Domain

  getter meta_error : String = ""

  before_save do
    domain_id.value = domain.id
    region_id.value = Region.default_region.id
  end

  before_save permit_only_one_monitor_per_domain

  def permit_only_one_monitor_per_domain
    return unless domain_fk = domain.id

    results = Monitor::IcmpQuery.new
      .domain_id(domain_fk)
      .first?

    if results
      # this won't ever show, but is needed to fail the validations
      domain_id.add_error "is already being checked"
      @meta_error = "Only one ICMP monitor can be present for a domain"
    end
  end
end
