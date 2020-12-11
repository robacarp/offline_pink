class Monitor::Http::ShowPage < AuthLayout
  needs monitor : Monitor::Http

  def content
    text "yolo http"
  end
end
