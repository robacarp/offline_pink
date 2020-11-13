class Notification {
  constructor(notification) {
    this.notification = notification
    notification.querySelector('.close').addEventListener('click', this.close)
  }

  close = evt => {
    this.notification.classList.add("closed")
  }
}

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll('.flash').forEach(flash => new Notification(flash))
})
