class Monitors::HTTP < BaseModel
  table :http_monitors do
    belongs_to domain : Domain

    column ssl : Bool
    column path : String
    column expected_status_code : Int32
    column expected_content : String?
  end
end
