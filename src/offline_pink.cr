require "amber"
require "mosquito"

require "./ext/extensions"

require "../config/*"
require "./models/model_helpers"
require "./models/**"
require "./mailers/**"
require "./handlers/**"

require "./policies/**"

# load the application_controller before controllers which depend on it
require "./controllers/application_controller"
require "./controllers/**"

require "./jobs/**"

Amber::Server.start
