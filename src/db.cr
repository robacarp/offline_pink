require "pg"
require "migrate"
require "../config/application"

command = ARGV[0]?

case command
when "migrate"
  MigrationRunner.new.migrate
when "rollback"
  MigrationRunner.new.rollback
when "status"
  MigrationRunner.new.status
when nil
  puts "Commands to manipulate the database: migrate, rollback, status"
else
  puts "unknown command '#{command}"
end

class MigrationRunner
  def initialize
    @migrator = Migrate::Migrator.new(
      DB.open(Amber.settings.database_url),
      Logger.new(STDOUT, level: Logger::DEBUG),
      File.join("db", "migrations"),
      "schema_version",
      "version"
    )
  end

  getter migrator

  def migrate
    migrator.to_latest
  end

  def rollback
    migrator.down
  end

  def pending?
    current_version = migrator.current_version
    current_version != migrator.next_version
  end

  def status
    current_version = migrator.current_version

    puts "Current version: #{migrator.current_version}."
    puts "Next version: #{migrator.next_version}."
    puts "There are pending migrations." if pending?
  end
end
