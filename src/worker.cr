require "../config/*"
Granite.settings.logger = Mosquito::Base.logger
Quartz.config.logger    = Mosquito::Base.logger
Mosquito::Runner.start
