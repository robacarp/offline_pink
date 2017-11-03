require "amber"
require "../config/application"

require "./models/**"
require "./mailers/**"
require "./handlers/**"

require "./mosquito/**"

require "./jobs/config"
require "./jobs/**"

Mosquito::Runner.start
