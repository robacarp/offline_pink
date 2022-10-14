abstract class BaseLayout
  include Foundation::LayoutHelpers::Authentication
  include Lucky::HTMLPage
  include HeaderAndLinks
  include ClassList
  include Theme::Form

  abstract def content

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      head do
        utf8_charset
        title "Offline.pink - #{page_title}"
        css_link "/css/app.css"
        js_link "/js/app.js", type: "module", defer: true
        csrf_meta_tags
        responsive_meta_tag
        live_reload_connect_tag
      end

      classes = [] of String
      classes << self.class.name.underscore.gsub(/::|_/, "-")
      classes.concat %w|
        max-w-screen-xl mx-auto
        px-2
        md:mx-auto md:w:2/3
        text-gray-100 bg-gray-900
      |

      body class: classes.join(' ') do
        mount Shared::NavBar, current_user, admin_user
        mount Shared::FlashMessages, context.flash
        sudo_toolbar if sudo_active?
        content
      end
    end
  end

  def sudo_toolbar
    return unless sudo_viewer = current_user

    mount Shared::AlertBox, severity: "info" do
      para do
        text "Impersonating user#"
        text sudo_viewer.id
        text "("
        text sudo_viewer.email
        text ")"
      end

      para do
        link "Return to safety", to: Admin::Users::EndImpersonation, data_confirm: "Are you sure?"
      end
    end
  end

  def fixed_width
    div class: "max-w-screen-xl w-full mx-auto h-screen p-4" do
      raw "<!-- fixed width -->"
      yield
    end
  end

  def centered
    div class: "w-full flex justify-center" do
      raw "<!-- centered -->"
      div do
        yield
      end
    end
  end

  def small_frame
    div class: "mx-auto w-full md:w-2/3" do
      raw "<!-- small frame -->"
      yield
    end
  end

  def text(time : Time)
    text time.to_rfc3339
  end

  def metric_unit_humanizer(unit : String?) : String
    case unit
    when Nil
      ""
    when "http_status_code"
      ""
    else
      unit
    end
  end

  def metric_name_humanizer(name : String) : String
    case name
    when "http_status_code"
      "HTTP Status"
    else
      name.gsub("_", " ").titleize
    end
  end
end
