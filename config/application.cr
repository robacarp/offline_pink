require "amber"
require "mosquito"

require "../src/ext/extensions"

require "./initializers/*"
require "./routes"

Amber::Server.configure do |settings|
  settings.database_url = ENV["DATABASE_URL"] if ENV["DATABASE_URL"]?
end

# load the application_ files before those which depend on them
require "../src/controllers/application_controller"
require "../src/mailers/application_mailer"

require "../src/models/model_helpers"
require "../src/models/**"
require "../src/mailers/**"
require "../src/handlers/**"

require "../src/policies/**"
require "../src/controllers/**"

require "../src/jobs/**"
