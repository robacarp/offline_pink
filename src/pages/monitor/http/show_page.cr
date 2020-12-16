class Monitor::Http::ShowPage < AuthLayout
  needs monitor : Monitor::Http

  def content
    small_frame do
      header_and_links do
        h1 "http monitor"

        div do
          a "delete", href: "#"
        end
      end
    end
  end
end
