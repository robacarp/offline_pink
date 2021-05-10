require "./foundation/**"

module Foundation
  Habitat.create do
    setting secret_key : String
    setting stubbed_token : String? = nil
    setting encryption_cost : Int32 = 10
  end
end
