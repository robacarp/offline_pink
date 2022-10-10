class Shared::FlashMessages < BaseComponent
  needs flash : Lucky::FlashStore

  def render
    return unless flash.any?

    div class: "w-full flex flex-col items-center space-y-4" do
      div class: "w-full md:w-4/12" do
        flash.each do |flash_type, flash_message|
          mount Shared::AlertBox, severity: flash_type do
            text flash_message
          end
        end
      end
    end
  end
end
