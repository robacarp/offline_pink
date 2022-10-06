import ApexCharts from "https://unpkg.com/apexcharts@3.7.0/dist/apexcharts.esm.js"
import _merge from "../lib/merge.js"

export default class Chart {
  constructor(container) {
    this.container = container
    this.monitorId = container.dataset.chartMonitorId
    this.url = container.dataset.chartUrl
    this.name = container.dataset.chartName
    this.type = container.dataset.chartType || "basic"
    this.refreshInterval = container.dataset.refreshInterval || 250
    this.fetchInterval = container.dataset.fetchInterval || 30000

    this.data = {}
    this.chart = null

    this.counter = 0
  }

  begin () {
    this.updateCounter()
    setInterval(this.updateCounter.bind(this), this.refreshInterval)
  }

  updateCounter () {
    this.counter -= this.refreshInterval
    this.container.dataset.refreshProgress = Math.trunc(100 * this.counter / this.fetchInterval)

    if (this.counter <= 0) {
      this.populate()
      this.counter = this.fetchInterval
    }
  }

  buildPoint(datum) {
    return {
      x: datum.timestamp,
      y: datum.value,
      monitorId: this.monitorId
    }
  }

  async makeRequest () {
    let raw_data = await fetch(this.url).then(response => response.json())
    this.data = raw_data.map(datum => this.buildPoint(datum))
  }

  async populate () {
    await this.makeRequest()
    if (this.chart === null) {
      this.chart = new ApexCharts(this.container, this.options())
      this.chart.render()
    } else {
      this.chart.updateOptions(this.options())
    }
  }

  dotClick (event, chartContext, { dataPointIndex }) {
    const point = this.data[dataPointIndex]
    const url = `/monitor/${point.monitorId}/event/${point.x}`
    window.location.href = url
  }

  pad (n) { return n >= 10 ? n : `0${n}` }

  x_axis_format (value) {
    const d = new Date(value * 1000)
    return this.formatted_time(d)
  }

  tooltip_format (value) {
    const d = new Date(value * 1000)
    return `${this.formatted_date(d)} ${this.formatted_time(d)}`
  }

  formatted_date (date) {
    return `${date.getFullYear()}-${this.pad(date.getMonth() + 1)}-${this.pad(date.getDay() + 1)}`
  }

  formatted_time (date) {
    return `${this.pad(date.getHours())}:${this.pad(date.getMinutes() + 1)}:${this.pad(date.getSeconds() + 1)}`
  }

  optionsForType () {
    return {}
  }

  options () {
    return _merge(this.defaultOptions(), this.optionsForType())
  }

  defaultOptions () {
    return {
      series: [{ name: this.name, data: this.data }],
      chart: {
        height: 350,
        type: 'line',
        zoom: { enabled: false },
        animations: { enabled: false },
        toolbar: { show: false },
        events: {
          dataPointSelection: this.dotClick.bind(this)
        }
      },
      noData: {
        text: "No Data"
      },
      dataLabels: { enabled: false },
      // stroke, smooth, stepline
      stroke: { curve: 'stepline', width: 2, colors: ['#ed03ff'] },
      theme: { mode: "dark", palette: "palette9" },
      xaxis: {
        type: 'datetime',
        labels: {
          formatter: this.x_axis_format.bind(this)
        },
        tooltip: { enabled: false }
      },
      yaxis: {
        crosshairs: { show: true },
        show: true,
        title: { text: this.name }
      },
      tooltip: {
        fixed: { enabled: true },
        x: { show: true, formatter: this.tooltip_format.bind(this) },
        y: { show: true }
      },
      markers: {
        size: 2,
        fillColors: "#ED03FF",
        strokeColors: "#ED03FF",
        strokeWidth: 2,
        hover: { size: 5 }
      },
    }
  }
}


export class ResponseTimeChart extends Chart {
  optionsForType () {
    return {
      chart: { type: 'scatter' },
    }
  }
}

export class HttpStatusCodeChart extends Chart {
  optionsForType () {
    return {
      chart: { type: 'scatter' },
      yaxis: {
        forceNiceScale: false,
        min: 100,
        max: 500,
        tickAmount: 4
      }
    }
  }
}
