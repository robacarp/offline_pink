module SaveMonitor
  macro included
    needs domain : Domain

    getter meta_error : String = ""

    before_save do
      monitor_type.value = type
      config.value = monitor_config
      domain_id.value = domain.id
      region_id.value = Region.default_region.id
    end

    before_save ensure_uniqueness_of_monitor
  end
end
