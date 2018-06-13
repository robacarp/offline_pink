class NotificationHandler
  record Link, text : String, url : String

  def self.to(user : User)
    new user
  end

  def initialize(@user : User)
  end

  def title(@title : String)
    self
  end

  def message(@message : String)
    self
  end

  def message(@title : String, @message : String)
    self
  end

  def reason(@reason : Symbol)
    self
  end

  def link(text : String, url : String)
    @link = Link.new text, url
    self
  end

  private def compiled_link
    if link = @link
      { link.text, link.url }
    else
      nil
    end
  end

  def send
    send_pushover
  end

  def validate_notification_components
    unless @user
      raise "No user provided for notification"
    end

    unless @reason
      raise "No reason provided for notification"
    end

    unless @title
      raise "No titile provided for notification"
    end

    unless @message
      raise "No message provided for notification"
    end
  end

  def send_pushover(*, validate_key = true) : Bool
    validate_notification_components

    log = SentNotification.new
    log.vendor = :pushover
    log.reason = @reason.not_nil!
    log.user_id = @user.id

    return false unless pushover_key = @user.pushover_key
    return false unless key = pushover_key.key
    return false unless ! validate_key || pushover_key.can_send?
    return false unless title = @title
    return false unless message = @message

    # TODO why aren't reason and vendor persisting to the database
    log.save

    success, _, _, body = Pushover.new(key).send(
      title,
      message,
      compiled_link
    )

    if success
      Amber.logger.info "Pushover notification sent: #{message} #{compiled_link}"
      true
    else
      # TODO: handle "invalid user key" failure
      Amber.logger.error "Pushover Notification Send failure: #{body}"
      false
    end
  end
end
