require "spec"

ENV["AMBER_ENV"] = "test"

require "amber"
require "../config/*"

require "micrate"
require "pg"

p Amber.settings.database_url

Granite::ORM.settings.logger = Logger.new nil
Micrate::DB.connection_url = Amber.settings.database_url
Micrate::Cli.run_up

Spec.before_each do
  Domain.clear
  GetResult.clear
  IpAddress.clear
  PingResult.clear
  Route.clear
  User.clear
end

require "garnet_spec"

module SystemTest
  DRIVER = :chrome
  PATH = "/usr/local/bin/chromedriver"
end
