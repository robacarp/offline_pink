abstract class BaseLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def current_user

  def div(selectors : String = "", *args, &block)
    id : String
    classes = ""

    selectors.split(".").each do |selector|
      if selector.starts_with? "#"
        id = selector
      else
        classes += " #{selector}"
      end
    end

    div(*args, id: id, class: classes)
  end

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title, context: context, current_user: current_user

      body class: self.class.name.underscore do
        mount Shared::NavBar
        mount Shared::FlashMessages, context.flash
        content
      end
    end
  end

  def fixed_width
    div class: "fixed-width" do
      yield
    end
  end
end
