require "http"
require "json"

class Pushover
  class Settings
    property app_key = ""
  end

  def self.settings
    @@_settings ||= Settings.new
  end

  record MessageLimit, limit : Int32, remaining : Int32, reset_at : Time

  def initialize(@user_key : String)
  end

  def request_headers
    HTTP::Headers { "Content-Type" => "application/json" }
  end

  def send(title : String, message : String, link : Tuple(String, String)?, priority = 0)
    message_body = JSON.build do |j|
      j.object do
        j.field "token", self.class.settings.app_key
        j.field "user", @user_key
        j.field "priority", 0 # -2, -1, 0, 1, 2
        j.field "title", title
        j.field "message", message

        if link
          j.field "url_text", link[0]
          j.field "url", link[1]
        end
      end
    end

    endpoint = "https://api.pushover.net/1/messages.json"

    response = HTTP::Client.post(endpoint, request_headers, body: message_body)

    limits = MessageLimit.new(
      response.headers["X-Limit-App-Limit"].to_i,
      response.headers["X-Limit-App-Remaining"].to_i,
      Time.epoch response.headers["X-Limit-App-Reset"].to_i
    )

    return {response.status_code == 200, limits, response.status_code, response.body}
  end
end

