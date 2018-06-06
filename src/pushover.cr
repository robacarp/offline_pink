require "http"
require "json"

app_key = ""
user_key = ""

device_name = "epo"
url = "https://api.pushover.net/1/messages.json"

headers = HTTP::Headers { "Content-Type" => "application/json" }
request_body = JSON.build do |j|
  j.object do
    j.field "token", app_key
    j.field "user", user_key
    j.field "device", device_name
    j.field "priority", 0 # -2, -1, 0, 1, 2
    j.field "sound", "tugboat"
    j.field "title", "testing offline.pink notification"
    j.field "message", "your domain might be offline"
  end
end

HTTP::Client.post(url, headers, body: request_body) do |response|
  puts response.status_code
  puts response.body
  puts pushover_messages_limit = response.headers["X-Limit-App-Limit"]
  puts pushover_messages_remaining = response.headers["X-Limit-App-Remaining"]
  puts pushover_limit_reset_at = Time.epoch response.headers["X-Limit-App-Reset"].to_i
end


