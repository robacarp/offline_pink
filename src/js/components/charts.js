"use strict";

import ApexCharts from "apexcharts"
import _ from "lodash"

class Chart {
  constructor(container) {
    this.container = container
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
      console.log(this.counter)
      this.populate()
      this.counter = this.fetchInterval
    }
  }

  async makeRequest () {
    let raw_data = await fetch(this.url).then(response => response.json())
    console.log(`got ${this.url} back with ${raw_data.length} elements`)
    this.data = raw_data.map(datum => { return [datum.timestamp, datum.value]; })
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
    return `${date.getFullYear()}-${this.pad(date.getMonth())}-${this.pad(date.getDay())}`
  }

  formatted_time (date) {
    return `${this.pad(date.getHours())}:${this.pad(date.getMinutes())}:${this.pad(date.getSeconds())}`
  }

  optionsForType () {
    return {}
  }

  options () {
    return _.merge(this.defaultOptions(), this.optionsForType())
  }

  defaultOptions () {
    return {
      series: [{ name: this.name, data: this.data }],
      chart: {
        height: 350,
        type: 'line',
        zoom: { enabled: false },
        animations: { enabled: false },
        toolbar: { show: false }
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


class ResponseTimeChart extends Chart {
  optionsForType () {
    return {
      chart: { type: 'scatter' },
    }
  }
}

class HttpStatusCodeChart extends Chart {
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

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll("[data-chart]").forEach(div => {
    let chart

    switch(div.dataset.chartType) {
      case "http_response_time":
      case "icmp_response_time":
        chart = new ResponseTimeChart(div)
        break
      case "http_status_code":
        chart = new HttpStatusCodeChart(div)
        break
      default:
        console.log(`could not build chart for ${this.type}`)
    }

    chart.begin()
  })
})
