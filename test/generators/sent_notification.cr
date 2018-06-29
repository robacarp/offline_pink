module Generate
  def sent_notification(**attributes)
    fields = {
      user_id: user!.id
    }.merge attributes

    SentNotification.new **fields
  end

  def sent_notification!(**a)
    sent_notification(**a).tap &.save
  end
end
