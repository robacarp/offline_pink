module Generate
  private def monitor_result_fields
    {
      domain_id: domain!.id,
      host_id: host!.id,
      monitor_id: http_monitor!.id,

      run_start_time: 3.seconds.ago,
      run_finish_time: Time.now,
      ok: true,

      host_resolution_failure: false,
      connect_failure: false,
      missing_host: false,
    }
  end

  def http_monitor_result(**attributes)
    fields = monitor_result_fields
     .merge({
       http_response_code: 200,
       http_response_time: 46.23_f32,
       http_content_found: true
     })
     .merge(attributes)
     .merge({monitor_type: "http"})

    MonitorResult.new(**fields)
  end

  def http_monitor_result!(**a)
    http_monitor_result(**a).tap &.save
  end

  def ping_monitor_result(**attributes)
    fields = monitor_result_fields
     .merge({
       ping_response_time: 212.19_f32
     })
     .merge(attributes)
     .merge({monitor_type: "ping"})

    MonitorResult.new(**fields)
  end

  def ping_monitor_result!(**a)
    ping_monitor_result(**a).tap &.save
  end
end
