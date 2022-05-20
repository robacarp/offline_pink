class Shared::FlashMessages < BaseComponent
  needs flash : Lucky::FlashStore

  def render
    return unless flash.any?

    div class: "w-full flex flex-col items-center" do
      flash.each do |flash_type, flash_message|
        # class flash is used to attach the event listener to the close action
        div class: "flash relative w-full md:w-4/12 flex border px-4 py-3 mb-4 rounded " + flash_style(flash_type),
          flow_id: "flash", role: "alert" do
          div flash_type, class: "font-bold mr-4 w-16"
          text flash_message

          span class: "close absolute top-0 bottom-0 right-0 px-4 py-3" do
            tag "svg", role: "button", class: "fill-current h-6 w-6", xmlns: "http://www.w3.org/2000/svg", viewBox:"0 0 20 20" do
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
  end

  private def flash_style(type)
    case type
    when "failure"
      "bg-red-100 border-red-400 text-red-700"
    when "success"
      "bg-green-100 border-green-400 text-green-700"
    when "info"
      "bg-blue-100 border-blue-400 text-blue-700"
    else
      ""
    end
  end

  private def flash_close_style(type)
    case type
    when "failure"
    when "success"
    when "info"
    end
  end
end
