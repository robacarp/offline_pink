require "./app"
require "mosquito"

Habitat.raise_if_missing_settings!

if LuckyEnv.development?
  Avram::Migrator::Runner.new.ensure_migrated!
  Avram::SchemaEnforcer.ensure_correct_column_mappings!
end

Avram.configure do |settings|
  settings.query_cache_enabled = false
end

Log.dexter.configure :debug, Log::IOBackend.new

Mosquito::Runner.start
