abstract class Layout
  include Lucky::HTMLPage

  include Shared::FieldErrors
  include Shared::FlashMessages
  include Shared::Field

  private def div(css_selectors : String, **other_args)
    classes = css_selectors.split '.'

    if classes[0].starts_with? '#'
      id = classes.shift.lstrip '#'
      div_args = other_args.merge({ id: id, class: classes.join(" ") })
    else
      div_args = other_args.merge({ class: classes.join(" ") })
    end

    div(div_args) do
      yield
    end
  end

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
        div "#vspacer" do
          div ".container" do
            navbar

            div ".row" do
              div ".col-md-12.main" do
                render_flash

                yield
              end
            end
          end
        end

        div "#footer" do
          div ".container" do
            hr
          end
        end
      end
    end
  end

  def navbar
    nav class: "navbar navbar-expand-lg bg-dark" do
      a "Offline.pink", class: "navbar-brand", href: "/"

      button class: "navbar-toggler", type: "button", "data-toggle": "collapse", "data-target": "#mainNavigation", "aria-controls": "mainNavigation", "aria-expanded": "false", "aria-label": "Toggle Navigation" do
        span class: "navbar-toggler-icon"
      end

      div id: "navbarSupportedContent", class: "collapse navbar-collapse"

      user_menu
    end
  end

  def user_menu
    ul class: "navbar-nav mr-auto" do
      if activated_user?
        li class: "nav-item" do
          a "Domains", href: "/domains", class: "nav-link"
        end
      end

      li class: "nav-item" do
        login_button
      end
    end
  end

  def login_button
    if @current_user
      link "Log Out", to: Session::Delete, class: "nav-link"
    else
      link "Log In", to: Session::New, class: "nav-link"
    end
  end

  private def activated_user? : Bool
    user = @current_user

    if user
      user.activated?
    else
      false
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
