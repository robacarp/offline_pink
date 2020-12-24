"use strict";

import ApexCharts from "apexcharts"
import _ from "lodash"

class Chart {
  constructor(container) {
    this.container = container
    this.url = container.dataset.chartUrl
    this.name = container.dataset.chartName
    this.type = container.dataset.chartType || "basic"
    this.data = {}
    this.chart = null
  }

  render () {
    this.populate()
    setInterval(this.populate.bind(this), 30000)
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

  httpCodeOptions() {
    return {
      stroke: { curve: "smooth" }
    }
  }

  optionsForType() {
    switch(this.type) {
      case "http_response_time":
        return this.httpCodeOptions()
        break
      case "http_code":
        return this.httpCodeOptions()
        break
    }
  }

  options () {
    return _.merge(this.basicOptions(), this.optionsForType())
  }

  basicOptions () {
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
        show: true
      },
      tooltip: {
        fixed: { enabled: true },
        x: { show: true, formatter: this.tooltip_format.bind(this) },
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

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll("[data-chart]").forEach(chart => {
    let apex = new Chart(chart)
    apex.render()
  })
})
