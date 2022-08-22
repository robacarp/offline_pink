class Home::Ping < BrowserAction
  allow_guests

  get "/ping" do
    # validate that the database is still connected
    region = nil

    Avram.temp_config(query_cache_enabled: false) do
      region = RegionQuery.first
    end


    response = Hash(String, String).new
    response["ok"] = "true"
    response["region"] = region.name

    response.merge! Build.details

    json response
  end
end
