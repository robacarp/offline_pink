Amber::MailerConfig.config do |c|
  c.smtp_address = "127.0.0.1"
  c.smtp_port    = 1025
  c.logger = Amber.settings.logger.dup
  c.smtp_enabled = true
end
