require "amber"
require "mosquito"

require "../config/*"
require "./models/**"
require "./mailers/**"
require "./handlers/**"

require "./policies/**"

# load the application_controller before controllers which depend on it
require "./controllers/application_controller"
require "./controllers/**"

require "./jobs/**"

Amber::Server.start
