require "http"
require "json"
require "habitat"

require "./pushover/*"

class Pushover
  API_VERSION = 1

  Habitat.create do
    setting app_key : String, example: "a12345678912345678912345678912"
    setting redis_url : String, example: "redis://localhost:6379"
  end

  def self.request_headers
    HTTP::Headers { "Content-Type" => "application/json" }
  end

  def send(
    user_key : String,
    title : String,
    message : String,
    link : Tuple(String, String)? = nil,
    priority = 0
  )

    return false unless APILimits.can_send?

    response = make_request url: "messages.json" do |builder|
      builder.field "user", user_key
      builder.field "priority", 0 # -2, -1, 0, 1, 2
      builder.field "title", title
      builder.field "message", message

      if link
        builder.field "url_text", link[0]
        builder.field "url", link[1]
      end
    end

    api_limits = APILimits.from response.raw
    api_limits.update
  end

  def validate_user_key(key : String) : Bool
    response = make_request url: "users/validate.json" do |builder|
      builder.field "user", key
    end

    response.success
  end





  private def make_request(url : String) : Response
    message_body = JSON.build do |builder|
      builder.object do
        builder.field "token", self.class.settings.app_key

        yield builder
      end
    end

    Response.from(request(url, message_body))
  end

  private def request(path : String, message_body : String)
    endpoint = Path["https://api.pushover.net/"].join API_VERSION, path
    HTTP::Client.post endpoint.to_s, self.class.request_headers, body: message_body
  end
end
