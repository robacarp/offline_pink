class Shared::FlashMessages < BaseComponent
  needs flash : Lucky::FlashStore

  def render
    return unless flash.any?

    div class: "flashes" do
      flash.each do |flash_type, flash_message|
        div class: "flash #{flash_type}", flow_id: "flash", role: "alert" do
          div flash_type, class: "title"
          text flash_message

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
  end

end
