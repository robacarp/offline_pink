module Generate
  def host(**attributes)
    fields = {
      address: "#{counter(:host)}.#{rand(0...255)}.#{rand(0...255)}.#{rand(0...254)}",
      ip_version: "ipv4",
      domain_id: domain!.id
    }.merge(attributes)

    Host.new(**fields)
  end

  def host!(**a)
    host(**a).tap &.save
  end
end
