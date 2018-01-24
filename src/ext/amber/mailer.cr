require "./mailer/config"

class Amber::Mailer
  property from = [] of EMail::Address
  property to   = [] of EMail::Address
  property cc   = [] of EMail::Address
  property bcc  = [] of EMail::Address

  property subject = ""
  property body = ""

  def to(email : String)
    @to << address email
  end

  def to(name : String, email : String)
    @to << address name, email
  end

  def subject(@subject : String)
  end

  def body(@body : String)
  end

  def address(email : String)
    EMail::Address.new email
  end

  def address(name : String, email : String)
    EMail::Address.new email, name
  end

  def deliver
    message = EMail::Message.new
    message.subject @subject
    message.message @body

    message.from sender

    @to.each do |person|
      message.to person
    end

    @cc.each do |person|
      message.cc person
    end

    @bcc.each do |person|
      message.bcc person
    end

    config = Amber::MailerConfig.config

    if config.smtp_enabled
      EMail::Sender.new(
        config.smtp_address, config.smtp_port,
        use_tls: config.use_ssl
      ).start do
        enqueue message
      end
    else
      puts "SMTP Disabled, not actually sending email"
    end
  end

  macro render(filename, layout, *args)
    content = render("{{filename.id}}", {{*args}})
    render("layouts/{{layout.id}}")
  end

  macro render(filename, *args)
    Kilt.render("src/views/{{filename.id}}", {{*args}})
  end
end
