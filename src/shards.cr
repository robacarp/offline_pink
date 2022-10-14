# Load .env file before any other config or app code
require "lucky_env"
LuckyEnv.load?(".env")

require "avram/lucky"
require "lucky_router"
require "lucky"
require "carbon"
require "carbon_sendgrid_adapter"
require "mosquito"
require "pundit"

require "./lib/notifier"
require "./lib/foundation"
require "./lib/featurette"
require "./lib/build"
require "./lib/errors"
require "./lib/poor_dns"
require "./apis/pushover"
