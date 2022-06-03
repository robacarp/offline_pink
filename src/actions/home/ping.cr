class Home::Ping < BrowserAction
  allow_guests

  get "/ping" do
    # validate that the database is still connected
    region = RegionQuery.first

    response = Hash(String, String).new
    response["ok"] = "true"
    response["region"] = region.name

    response.merge! Build.details

    json response
  end
end
