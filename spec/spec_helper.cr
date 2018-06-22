require "envy"
Envy.load "test.env" do
  { raise_exception: true }
end

require "spec"

require "amber"
require "../config/*"

require "micrate"
require "pg"

Granite.settings.logger = Logger.new nil
Micrate::DB.connection_url = Amber.settings.database_url
Micrate::Cli.run_up

Spec.before_each do
  Domain.clear
  Host.clear
  Invite.clear
  Monitor.clear
  MonitorResult.clear
  PushoverKey.clear
  SentNotification.clear
  User.clear
end

require "garnet_spec"

module SystemTest
  DRIVER = :chrome
  PATH = "/usr/local/bin/chromedriver"
end
