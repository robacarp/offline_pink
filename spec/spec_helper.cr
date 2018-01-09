require "spec"

ENV["AMBER_ENV"] = "test"

require "amber"
require "../config/*"

require "micrate"
require "pg"
require "sqlite"
require "mysql"
Micrate::DB.connection_url = Amber.settings.database_url
Micrate::Cli.run_up

require "../src/ext/extensions"
require "../src/controllers/application_controller"
require "../src/controllers/**"
require "../src/mailers/**"
require "../src/models/**"
require "../src/policies/**"

Spec.before_each do
  Route.clear
  User.clear
  PingResult.clear
  GetResult.clear
  Check.clear
end
