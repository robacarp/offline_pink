import ApexCharts from "apexcharts"

class Chart {
  constructor(container) {
    this.container = container
    this.url = container.dataset.chartUrl
    this.name = container.dataset.chartName
  }

  async populate () {
    let data = await fetch(this.url).then(data => data.json())
    console.log(`got ${this.url} back with ${data.length} elements`)
    data = data.map(datum => { return [datum.timestamp, datum.value]; })
    let options = this.options()
    options.series = [{ name: `${this.name}`, data: data }]

    var chart = new ApexCharts(this.container, options)
    chart.render()
  }

  x_formatter = function (value) {
    const pad = (n) => { return n >= 10 ? n : `0${n}` }
    const d = new Date(value * 1000)
    return `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`
  }

  options = function () {
    return {
      chart: {
        height: 350,
        type: 'line',
        zoom: { enabled: false },
        animations: { enabled: false },
        toolbar: { show: false }
      },
      dataLabels: { enabled: false },
      stroke: { curve: 'smooth', width: 2, colors: ['#ed03ff'] },
      theme: { mode: "dark", palette: "palette9" },
      xaxis: {
        type: 'datetime',
        labels: {
          formatter: this.x_formatter
        },
        tooltip: { enabled: false }
      },
      yaxis: {
        crosshairs: { show: true },
        show: true
      },
      tooltip: {
        fixed: { enabled: true },
        x: { show: true },
        y: { show: true }
      },
      markers: {
        hover: {
          size: 1
        }
      }
    }
  }
}

/*
        document.addEventListener("turbolinks:load", async () => {
        })
*/

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll("[data-chart]").forEach(chart => {
    (new Chart(chart)).populate()
  })
})
