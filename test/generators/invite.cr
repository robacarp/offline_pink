module Generate
  def invite(**attributes)
    fields = {
      uses_remaining: 1_i64
    }.merge(attributes)

    Invite.new(**fields)
  end

  def invite!(**a)
    invite(**a).tap &.save
  end
end
