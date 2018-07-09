require "envy"
Envy.load "test.env" do
  { raise_exception: true }
end

require "amber"
require "../config/*"

require "./generate"
require "migrate"
require "minitest/autorun"
require "minitest/focus"

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
