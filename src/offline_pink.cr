require "amber"
require "../config/*"
require "./models/**"
require "./mailers/**"
require "./handlers/**"

require "./policies/**"

# load the application_controller before controllers which depend on it
require "./controllers/application_controller"
require "./controllers/**"

require "./mosquito/**"

require "./jobs/config"
require "./jobs/**"

Amber::Server.start
