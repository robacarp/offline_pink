class HomePage < GuestLayout
  def content
    div class: "small-frame sm:flex sm:flex-row-reverse" do
      div class: "mb-6 w-48 sm:w-2/5 sm:pl-3 sm:mb-0" do
        img src: "assets/images/undraw_connected_world_wuay.svg"
      end

      div class: "sm:w-3/5" do
        para do
          strong "Service Availability Monitoring"
        end
        para do
          text "Ensure your services are availale for your customers all day, every day"
        end

        para class: "mt-8" do
          strong "Flexible notifications"
        end
        para do
          text "Notify yourself directly with Pushover, and then direct the message according to any or all devices on your own schedule"
        end
      end

    end
  end
end
