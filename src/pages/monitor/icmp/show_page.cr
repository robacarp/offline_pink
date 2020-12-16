class Monitor::Icmp::ShowPage < AuthLayout
  needs monitor : Monitor::Icmp

  def content
    small_frame do
      header_and_links do
        h1 "icmp monitor"

        div do
          a "delete", href: "#"
        end
      end
    end
  end
end
