module Generate
  private def monitor_fields
    {
      domain_id: domain!.id
    }
  end

  def http_monitor(**attributes)
    fields = monitor_fields
      .merge({
        http_path: "/page#{counter(:monitor)}",
        http_use_ssl: true,
        http_expected_status_code: 200,
        http_expected_content: "<html",
      })
      .merge(attributes)
      .merge({
        monitor_type: "http"
      })

    Monitor.new(**fields)
  end

  def http_monitor!(**a)
    http_monitor(**a).tap &.save
  end

  def icmp_monitor(**attributes)
    fields = monitor_fields
      .merge(attributes)
      .merge({
        monitor_type: "ping"
      })

    Monitor.new(**fields)
  end

  def icmp_monitor!(**a)
    icmp_monitor(**a).tap &.save
  end
end
