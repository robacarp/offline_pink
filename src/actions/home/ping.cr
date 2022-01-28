class Home::Ping < BrowserAction
  allow_guests

  get "/ping" do
    response = Hash(String, String).new
    response["ok"] = "true"

    response.merge! Build.details

    json response
  end
end
