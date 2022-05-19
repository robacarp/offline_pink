abstract class BaseLayout
  include Foundation::LayoutHelpers::Authentication
  include Lucky::HTMLPage
  include HeaderAndLinks

  abstract def content

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title, current_user: current_user

      classes = [] of String
      classes << self.class.name.underscore.gsub(/::|_/, "-")

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
    div class: "fixed-width" do
      yield
    end
  end

  def centered
    div class: "w-full flex justify-center" do
      div do
        yield
      end
    end
  end

  def small_frame
    div class: "prose mx-auto w-full px-6 md:px-0 md:w-5/6" do
      yield
    end
  end


  def formatted_status(for domain : Domain)
    domain.status_code.to_s.downcase
  end

  def text(time : Time)
    text time.to_rfc3339
  end
end
