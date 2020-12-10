class Monitor::Http < Monitor::Base
  policy!

  table :http_monitors do
    belongs_to domain : Domain
    belongs_to region : Region

    column ssl : Bool = true
    column path : String = "/"
    column expected_status_code : Int32 = 200
    column expected_content : String?
  end

  def type
    "HTTP"
  end

  def ssl?
    ssl
  end

  def string_config : String
    String.build do |s|
      s << "(SSL) " if ssl?

      s << "'"
      s << path
      s << "' : "

      s << expected_status_code
    end
  end

  def summary : String
    String.build do |s|
      s << "http"
      s << "s" if ssl?
      s << " '"
      s << path
      s << "' => "
      s << expected_status_code
      s << "(with search content)" unless expected_content.blank?
    end
  end
end
