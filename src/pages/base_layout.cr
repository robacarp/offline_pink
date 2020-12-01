abstract class BaseLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def current_user

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title, context: context, current_user: current_user

      classes = [] of String
      classes << self.class.name.underscore.gsub(/::|_/, "-")

      body class: classes.join(' ') do
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

  def shrink_to_fit
    div class: "shrink-to-fit" do
      div do
        yield
      end
    end
  end

  def small_frame
    div class: "small-frame" do
      yield
    end
  end
end
