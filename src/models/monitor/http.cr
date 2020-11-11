class Monitor::HTTP < Monitor::Base
  table :http_monitors do
    belongs_to domain : Domain
    belongs_to region : Region

    column ssl : Bool
    column path : String
    column expected_status_code : Int32
    column expected_content : String?
  end

  def type
    "HTTP"
  end

  def ssl?
    ssl
  end
end
