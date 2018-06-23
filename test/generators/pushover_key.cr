module Generate
  def pushover_key(**attributes)
    fields = {
      key: "0000abadidea",
      user_id: user!
    }.merge(attributes)

    PushoverKey.new(**fields)
  end

  def pushover_key!(**a)
    pushover_key(**a).tap &.save
  end
end
