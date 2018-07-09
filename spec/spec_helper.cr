require "envy"
Envy.load "test.env" do
  { raise_exception: true }
end

require "amber"
require "../config/*"

require "./generate"
require "migrate"

spec_logger = Logger.new STDOUT, level: Logger::WARN
spec_logger = Logger.new nil
Granite.settings.logger = spec_logger

Migrate::Migrator.new(
  DB.open(Amber.settings.database_url),
  spec_logger,
  File.join("db", "migrations"),
  "schema_version",
  "version"
).tap do |migrator|
  migrator.reset
  migrator.to_latest
end

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

require "spec"
require "garnet_spec"

module SystemTest
  DRIVER = :chrome
  PATH = "/usr/local/bin/chromedriver"
end
