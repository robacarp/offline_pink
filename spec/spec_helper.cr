require "spec"

ENV["AMBER_ENV"] = "test"

require "amber"
require "../config/*"

require "micrate"
require "pg"

Granite::ORM.settings.logger = Logger.new nil
Micrate::DB.connection_url = Amber.settings.database_url
Micrate::Cli.run_up

Spec.before_each do
  Domain.clear
  Monitor.clear
  MonitorResult.clear
  Host.clear
  User.clear
end

require "garnet_spec"

module SystemTest
  DRIVER = :chrome
  PATH = "/usr/local/bin/chromedriver"
end
