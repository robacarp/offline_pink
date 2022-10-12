export default class Notification {
  constructor(notification) {
    this.notification = notification
    notification.querySelector('[data-close-button]').addEventListener('click', this.close)
  }

  close = evt => {
    this.notification.classList.add("hidden")
  }
}
