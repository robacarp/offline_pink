import Builder from './builder.js'

class Confirm {
  constructor(link) {
    this.link = link
    link.addEventListener('click', this.click)
  }

  click = evt => {
    const response = window.confirm(this.link.dataset.confirm)
    if (response !== true) {
      evt.stopImmediatePropagation()
      evt.preventDefault()
    }
  }
}

class MethodOverride {
  constructor(link) {
    this.link = link
    link.addEventListener('click', this.click)
  }

  click = evt => {
    evt.preventDefault()

    const form = Builder.form('post', this.link.href)
    const submit = Builder.input('submit')
    form.appendChild(Builder.input('hidden', '_method', this.link.dataset.method))
    form.appendChild(submit)

    if (! UJS.isCrossDomain(this.link.href))
      form.appendChild(Builder.input('hidden', UJS.csrfParam, UJS.csrfToken))

    form.target = this.link.target
    form.style.display = 'none'
    document.body.appendChild(form)

    submit.click()
  }
}

export default class UJS {
  static start () {
    document.querySelectorAll('[data-confirm]').forEach(link => new Confirm(link))
    document.querySelectorAll('[data-method]').forEach(link => new MethodOverride(link))
    this.updateFormCsrfTokens()
  }

  static updateFormCsrfTokens () {
    const token = this.csrfToken
    document.querySelectorAll(`input[name="${this.csrfParam}"]`).forEach(input => input.value = token)
  }

  static get csrfToken () {
    const meta = document.querySelector('meta[name=csrf-token]')
    return meta.content
  }

  static get csrfParam () {
    const meta = document.querySelector('meta[name=csrf-param]')
    return meta.content
  }

  static isCrossDomain (url) {
    const baseUrl = new URL(location.href)
    const candidateUrl = new URL(url)

    return baseUrl.host != candidateUrl.host
        || baseUrl.protocol != candidateUrl.protocol
  }
}
