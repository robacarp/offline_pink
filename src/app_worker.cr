require "./app"
require "mosquito"

Habitat.raise_if_missing_settings!

if Lucky::Env.development?
  Avram::Migrator::Runner.new.ensure_migrated!
  Avram::SchemaEnforcer.ensure_correct_column_mappings!
end

Mosquito::Runner.start
