require "amber"
require "mosquito"

require "./ext/extensions"

# load the application_ files before those which depend on them
require "./controllers/application_controller"
require "./mailers/application_mailer"

require "../config/*"
require "./models/model_helpers"
require "./models/**"
require "./mailers/**"
require "./handlers/**"

require "./policies/**"
require "./controllers/**"

require "./jobs/**"

Amber::Server.start
