class Monitor::Http < Monitor::Base
  policy!

  table :http_monitors do
    belongs_to domain : Domain
    belongs_to region : Region

    column ssl : Bool = true
    column path : String = "/"
    column expected_status_code : Int32 = 100
    column expected_content : String?
  end

  def type
    "HTTP"
  end

  def ssl?
    ssl
  end

  def summary : String
    String.build do |s|
      s << "path:"
      s << path
      s << " with SSL" if ssl?
    end
  end
end
