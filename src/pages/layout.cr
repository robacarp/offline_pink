abstract class Layout
  include Lucky::HTMLPage
  include Shared::FieldErrors
  include Shared::FlashMessages
  include Shared::Field

  def shell
    html_doctype

    html lang: "en" do
      head do
        utf8_charset
        title "Offline.pink - #{page_title}"
        css_link asset("css/app.css"), data_turbolinks_track: "reload"
        js_link asset("js/app.js"), defer: "true", data_turbolinks_track: "reload"
        csrf_meta_tags
        responsive_meta_tag
      end

      body do
        div id: "vspacer" do
          div class: "container" do
            navbar
            render_flash

            div class: "row" do
              div class: "col-md-12 main" do
                yield
              end
            end
          end
        end

        div id: "footer" do
          div class: "container" do
            hr
          end
        end
      end
    end
  end

  def navbar
    nav class: "navbar navbar-expand-lg bg-dark" do
      a class: "navbar-brand", href: "/" do
        text "Offline.pink"
      end

      button class: "navbar-toggler", type: "button", "data-toggle": "collapse", "data-target": "#mainNavigation", "aria-controls": "mainNavigation", "aria-expanded": "false", "aria-label": "Toggle Navigation" do
        span class: "navbar-toggler-icon"
      end

      div id: "navbarSupportedContent", class: "collapse navbar-collapse"

      ul class: "navbar-nav mr-auto" do
        # if current_user.activated?
        li class: "nav-item" do
          a href: "/domains" do
            text "Domains"
          end
        end


        # if current_user.logged_in?
        li class: "nav-item dropdown" do
          a class: "nav-link dropdown-toggle", href: "#", role: "button", "data-toggle": "dropdown" do
            text "Settings"
          end

          div class: "dropdown-menu" do
            a class: "dropdown-item", href: "/account" do
              text "Account"
            end

            # if current_user.can? :use_pushover
            a class: "dropdown-item", href: "/pushover_settings" do
              text "Pushover"
            end
          end
        end


        # else
        li class: "nav-item" do
          a class: "nav-link", href: "/login" do
            text "Log in"
          end
        end
      end
    end
  end

  def render
    shell do
      content
    end
  end

  abstract def content
  abstract def page_title

  def page_title
    "Welcome"
  end
end
