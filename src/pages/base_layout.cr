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

    div id: "sudo-toolbar" do
      para do
        text "Impersonating "
        text sudo_viewer.email
      end

      link to: Admin::Users::EndImpersonation, data_confirm: "Are you sure?" do
        span class: "close" do
          tag "svg", role: "button", xmlns: "http://www.w3.org/2000/svg", viewBox:"0 0 20 20" do
            tag "title", "Close"
            tag "path",
              d: <<-SVG
                M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z
              SVG
          end
        end
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
end
