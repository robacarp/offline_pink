module Generate
  def pushover_key(**attributes)
    fields = {
      key: "0000abadidea",
      user_id: user!.id,
      verification_sent_at: 30.minutes.ago
    }.merge(attributes)

    PushoverKey.new(**fields)
  end

  def pushover_key!(**a)
    pushover_key(**a).tap &.save
  end
end
