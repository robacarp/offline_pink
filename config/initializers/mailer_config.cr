Quartz.config do |c|
  c.smtp_address = ENV["SMTP_ADDRESS"]?  || "smtp.sendgrid.net"
  c.smtp_port    = ENV["SMTP_PORT"]?     || 587
  c.username     = ENV["SMTP_USER"]?     || "apikey"
  c.password     = ENV["SMTP_PASSWORD"]? || ""

  c.logger = Amber.settings.logger.dup
  c.logger.level    = Logger::Severity::DEBUG
  c.logger.progname = "Email"

  c.use_authentication = c.use_tls = ! ENV["SMTP_PASSWORD"]?.nil?
  c.smtp_enabled = true
end

