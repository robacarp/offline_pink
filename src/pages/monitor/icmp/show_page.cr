class Monitor::Icmp::ShowPage < AuthLayout
  needs monitor : Monitor::Icmp

  def content
    text "yolo icmp"
  end
end
