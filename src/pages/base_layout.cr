abstract class BaseLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def current_user
  abstract def admin_user

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
        mount Shared::NavBar, current_user, admin_user
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

  def header_and_links
    div class: "header-and-links" do
      yield
    end

    hr
  end

  def middot_sep
    raw "&nbsp;&middot;&nbsp;"
  end

  def formatted_status(for domain : Domain)
    domain.status_code.to_s.downcase
  end

  def text(time : Time)
    text time.to_rfc3339
  end
end
