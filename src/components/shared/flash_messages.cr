module Shared::FlashMessages
  def render_flash
    div class: "container" do
      div class: "row" do
        @context.flash.each do |flash_type, flash_message|
          div class: "alert alert-#{decode_flash flash_type}", flow_id: "flash" do
            para do
              text flash_message
            end
          end
        end
      end

      div class: "row" do
      end
    end
  end

  def decode_flash(message)
    case message
    when "failure"
      "danger"
    else
      message
    end
  end
end
