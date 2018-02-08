require "spec"

ENV["AMBER_ENV"] = "test"

require "amber"
require "../config/*"

require "micrate"
require "pg"

Granite::ORM.settings.logger = Logger.new nil
Micrate::DB.connection_url = Amber.settings.database_url
Micrate::Cli.run_up

require "../src/ext/extensions"
require "../src/controllers/application_controller"
require "../src/controllers/**"
require "../src/mailers/**"
require "../src/models/**"
require "../src/policies/**"

Spec.before_each do
  Domain.clear
  GetResult.clear
  IpAddress.clear
  PingResult.clear
  Route.clear
  User.clear
end
