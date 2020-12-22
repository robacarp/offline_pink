class Monitor::ShowPage < AuthLayout
  needs monitor : Monitor
  needs domain : Domain

  def content
    small_frame do
      header_and_links do
        h1 do
          text domain.name
          middot_sep
          text monitor.summary
        end

        div do
          link "stop monitoring", to: Monitor::Delete.with(monitor), data_confirm: "Are you sure?"
        end
      end

      last_monitor_output
      hr
      chart_for Monitor::Http::Data.with(monitor), "http_response_time"
      chart_for Monitor::Http::Data.with(monitor), "http_status_code"
    end
  end

  def last_monitor_output
    output = monitor.last_monitor_output

    if output.select_count <= 0
      para "No monitor logs"
      return
    end

    div class: "log-output" do
      output.each do |log_line|
        classes = ["entry"]
        classes << log_line.severity.to_s.downcase
        classes << "monitor" if log_line.attached_monitor?

        span class: classes.join(' ') do
          text log_line.text
        end

        br
      end
    end
  end

  def chart_for(endpoint, name)
    chart_id = [name, "chart"].join("_")
    div id: chart_id

    tag "script" do
      raw <<-JAVASCRIPT
        document.addEventListener("turbolinks:load", async () => {
          data = await fetch("#{endpoint.path}?metric=#{name}").then(data => data.json())
          console.log(`got #{endpoint.path} back with ${data.length} elements`)
          data = data.map(datum => { return [datum.timestamp, datum.value]; })
          var chart = new ApexCharts(document.querySelector("##{chart_id}"),
            {
              series: [{ name: "#{name}", data: data }],
              chart: {
                height: 350,
                type: 'line',
                zoom: { enabled: false },
                animations: { enabled: false },
                toolbar: { show: false }
              },
              dataLabels: { enabled: false },
              stroke: { curve: 'straight', width: 2, colors: ['#ed03ff'] },
              theme: { mode: "dark", palette: "palette9" },
              xaxis: {
                type: 'datetime',
                labels: {
                  formatter: function (value) {
                    d = new Date(value * 1000)
                    return `${d.getFullYear()}-${d.getMonth()}-${d.getDay()} ${d.getHours()}:${d.getMinutes()}:${d.getSeconds()}`
                  }
                },
                tooltip: { enabled: false }
              },
              tooltip: {
                x: { show: true },
                y: { show: true }
              },
              legend: {
                show: false
              }
            }
          )
          chart.render()
        })
      JAVASCRIPT
    end
  end

end
