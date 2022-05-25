export default class Builder {
  static tag(name, text) {
    const tag = document.createElement(name)
    tag.textContent = text
    return tag
  }

  static link(href, text) {
    const link = Builder.tag("a", text)
    link.href = href
    return link
  }

  static option(text, value = null) {
    if (value == null)
      value = text

    const option = Builder.tag("option",text)
    option.value = value
    return option
  }

  static img(image) {
    const tag = document.createElement('img')
    tag.src = image.url
    tag.dataset.imageId = image.id
    return tag
  }

  static form(method, action) {
    const tag = Builder.tag('form')
    tag.method = method
    tag.action = action
    return tag
  }

  static input(type, name, value) {
    const tag = document.createElement('input')
    tag.type = type
    tag.name = name
    tag.value = value
    return tag
  }
}
