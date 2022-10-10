import Notification from './components/notifications.js'
import { ResponseTimeChart, HttpStatusCodeChart } from './components/charts.js'
import Tabs from './components/tabs.js'
import UJS from './lib/ujs.js'

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(`[data-behavior~=tabs]`).forEach(tabs => {
    new Tabs(tabs)
  })

  document.querySelectorAll('[data-has-close-button]').forEach(flash => new Notification(flash))

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
        console.log(`could not build chart for ${div}`)
    }

    chart.begin()
  })

  UJS.start()
})
