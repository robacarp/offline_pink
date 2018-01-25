require "amber"
require "mosquito"

require "./ext/extensions"

require "../config/application"

require "./models/**"
require "./mailers/**"
require "./handlers/**"

require "./jobs/**"

Granite::ORM.settings.logger = Mosquito::Base.logger
Mosquito::Runner.start
