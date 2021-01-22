Pushover.configure do |settings|
  settings.app_key = ENV["PUSHOVER_APP_KEY"]? || "amn1qwtuw49qniq8q5mh2wpscd4yi9"
  settings.redis_url = ENV["REDIS_URL"]? || "redis://localhost:6379"
end
