# Load .env file before any other config or app code
require "lucky_env"
LuckyEnv.load?(".env")

require "avram"
require "lucky_router"
require "lucky"
require "carbon"
require "carbon_sendgrid_adapter"
require "mosquito"
require "pundit"
# require "breeze"

require "./lib/notifier"
require "./lib/foundation"
require "./lib/featurette"
require "./lib/build"
require "./apis/pushover"
