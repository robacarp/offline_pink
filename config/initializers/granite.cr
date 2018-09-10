require "granite/adapter/pg"

database_url = Amber.settings.database_url
if url = ENV["DATABASE_URL"]?
  database_url = url
end

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: database_url})
Granite.settings.logger = Amber.settings.logger.dup
Granite.settings.logger.progname = "Granite"
