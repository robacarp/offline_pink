##########################
# CONFIG
##########################

# select and require the appropriate database driver here:
require "pg"
# require "sqlite"
# require "mysql"

TABLE_NAME = "schema_version"
COLUMN_NAME = "version"

migration_path = "db/migrations"
MIGRATION_FILE_REGEX = /(?<version>\d+)(_(?<name>\w+))?\.sql/
MIGRATION_CMD_PREFIX = /-- \+micrate/
NEW_MIGRATION_CMD = "-- +migrate"

##########################
# Rewriting migration files
##########################

require "colorize"

glob = File.join Dir.current, migration_path, "*.sql"
puts "Searching in #{glob}"

migration_versions = [] of String

Dir[glob].each_with_index do |entry, i|
  filename = File.basename entry

  unless filename_parts = MIGRATION_FILE_REGEX.match(filename)
    puts "#{filename} doesnt match, skipping"
    next
  end

  migration_versions << filename_parts["version"]

  lines = File.read_lines entry
  lines_changed = 0
  lines.map! do |line|
    if MIGRATION_CMD_PREFIX.match line
      lines_changed += 1
      line.gsub MIGRATION_CMD_PREFIX, NEW_MIGRATION_CMD
    else
      line
    end
  end

  if lines_changed > 0
    print "rewriting: ".colorize(:green)
    puts filename
    lines.push "" if lines.last != ""
    File.write entry, lines.join("\n")
  end
end

last_version = migration_versions.sort.last

###############################
# WRITING NEW MIGRATION HISTORY
###############################

database_connection = DB.open(Amber.settings.database_url)

statements = [] of String
statements << "DROP TABLE IF EXISTS #{TABLE_NAME}"
statements << "CREATE TABLE #{TABLE_NAME} (#{COLUMN_NAME} BIGINT NOT NULL)"
statements << "TRUNCATE TABLE #{TABLE_NAME}"
statements << "INSERT INTO #{TABLE_NAME} (#{COLUMN_NAME}) VALUES (#{last_version})"
statements << "DROP TABLE IF EXISTS micrate_db_version"

statements.each do |statement|
  database_connection.exec statement
end


###############################
# CONNECT MIGRATOR AND GET STATUS
###############################

require "../config/application"
require "migrate"

migrator = Migrate::Migrator.new(
  database_connection,
  Logger.new(STDOUT),
  File.join("db", "migrations"), # Path to migrations
  TABLE_NAME,     # Version table name
  COLUMN_NAME          # Version column name
)

puts "connected to #{Amber.settings.database_url}"
puts "current version: #{migrator.current_version}"
puts "next version: #{migrator.next_version}"
puts "previous version: #{migrator.previous_version}"
