class Errors::ShowPage
  include Lucky::HTMLPage

  needs message : String
  needs status_code : Int32

  def render
    html_doctype
    html lang: "en" do
      head do
        utf8_charset
        title "Something went wrong"
        normalize_styles
        error_page_styles
      end

      body do
        header do
          a href: "/", class: "logo" do
            text "Offline."
            span class: "pink" do
              text "pink"
            end
          end
        end

        div class: "container" do
          h2 status_code, class: "status-code"
          h1 message, class: "message"

          img src: "/assets/images/undraw_predictive_analytics_kf9n.svg"
          hr

          ul class: "helpful-links" do
            li do
              a "Try heading back to home", href: "/", class: "helpful-link"
            end
          end
        end
      end
    end
  end

  def normalize_styles
    style <<-CSS
      /*! normalize.css v7.0.0 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}body{margin:0}article,aside,footer,header,nav,section{display:block}h1{font-size:2em;margin:.67em 0}figcaption,figure,main{display:block}figure{margin:1em 40px}hr{box-sizing:content-box;height:0;overflow:visible}pre{font-family:monospace,monospace;font-size:1em}a{background-color:transparent;-webkit-text-decoration-skip:objects}abbr[title]{border-bottom:none;text-decoration:underline;text-decoration:underline dotted}b,strong{font-weight:inherit}b,strong{font-weight:bolder}code,kbd,samp{font-family:monospace,monospace;font-size:1em}dfn{font-style:italic}mark{background-color:#ff0;color:#000}small{font-size:80%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sub{bottom:-.25em}sup{top:-.5em}audio,video{display:inline-block}audio:not([controls]){display:none;height:0}img{border-style:none}svg:not(:root){overflow:hidden}button,input,optgroup,select,textarea{font-family:sans-serif;font-size:100%;line-height:1.15;margin:0}button,input{overflow:visible}button,select{text-transform:none}[type=reset],[type=submit],button,html [type=button]{-webkit-appearance:button}[type=button]::-moz-focus-inner,[type=reset]::-moz-focus-inner,[type=submit]::-moz-focus-inner,button::-moz-focus-inner{border-style:none;padding:0}[type=button]:-moz-focusring,[type=reset]:-moz-focusring,[type=submit]:-moz-focusring,button:-moz-focusring{outline:1px dotted ButtonText}fieldset{padding:.35em .75em .625em}legend{box-sizing:border-box;color:inherit;display:table;max-width:100%;padding:0;white-space:normal}progress{display:inline-block;vertical-align:baseline}textarea{overflow:auto}[type=checkbox],[type=radio]{box-sizing:border-box;padding:0}[type=number]::-webkit-inner-spin-button,[type=number]::-webkit-outer-spin-button{height:auto}[type=search]{-webkit-appearance:textfield;outline-offset:-2px}[type=search]::-webkit-search-cancel-button,[type=search]::-webkit-search-decoration{-webkit-appearance:none}::-webkit-file-upload-button{-webkit-appearance:button;font:inherit}details,menu{display:block}summary{display:list-item}canvas{display:inline-block}template{display:none}[hidden]{display:none}
    CSS
  end

  def error_page_styles
    style <<-CSS
      a {
        text-decoration: none;
      }
      body {
        color: #f7fafc;
        background-color: #1a202c;
        font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"
      }

      header {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
        padding: 1.5rem;
        margin-left: auto;
        margin-right: auto;
        width: 48rem;
        position: relative;
      }

      hr {
        border: 1px solid #EFEFEF;
        margin-top: 0.5rem;
        margin-bottom: 0.5rem;
      }


      .logo {
        display: flex;
        align-items: center;
        flex-shrink: 0;
        margin-right: 1.5rem;
        color: #fff;
        font-weight: 600;
        font-size: 1.25rem;
        letter-spacing: -0.025em;
      }

      .pink {
        color: #ed03ff;
      }

      .helpful-links {
        list-style-type: none;
        margin: 0;
        padding: 0;
      }

      .helpful-link {
        color: #02ffee;
      }

      .status-code {
        opacity: 0.4;
        font-size: 26px;
        font-weight: normal;
      }

      .message {
        font-size: 34px;
        line-height: 56px;
        font-weight: normal;
      }

      .container {
        margin: 0 auto;
        max-width: 450px;
        padding: 55px;
      }

      .container img {
        width: 100%;
      }

      @media only screen and (max-width: 500px) {
        .status-code {
          font-size: 18px;
        }

        .message {
          font-size: 26px;
          line-height: 40px;
          margin: 20px 0 35px 0;
        }
      }
    CSS
  end
end
