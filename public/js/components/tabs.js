export default class Tabs {
  constructor(tabs) {
    tabs.querySelectorAll(".tab").forEach( tab => {
      tab.addEventListener('click', this.clicked)
    })
  }

  clicked = evt => {
    evt.preventDefault()

    if (evt.target.classList.contains("active")) return

    const pane = document.querySelector(evt.target.attributes.href.value)
    const panes = pane.parentNode.querySelectorAll('.pane')

    const tab = evt.target
    const tabs = evt.target.parentNode.querySelectorAll('.tab')

    panes.forEach(e => { e.classList.remove("active")})
    tabs.forEach(e => { e.classList.remove("active") })

    setTimeout(() => {
      tab.classList.add("active")
      pane.classList.add("active")
    }, 50)
  }
}

