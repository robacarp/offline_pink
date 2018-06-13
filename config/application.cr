require "amber"
require "mosquito"
require "../src/pink_authorization/all.cr"

require "../src/ext/extensions"
require "../src/apis/*"

require "./initializers/*"

Amber::Server.configure do |settings|
  settings.database_url = ENV["DATABASE_URL"] if ENV["DATABASE_URL"]?
end

# load the application_ files before those which depend on them
require "../src/controllers/application_controller"
require "../src/mailers/application_mailer"

require "../src/policies/application_policy"

require "../src/models/**"
require "../src/mailers/**"
require "../src/handlers/**"
require "../src/messengers/**"

require "../src/policies/**"
require "../src/controllers/**"

require "../src/jobs/**"
