module Generate
  def domain(**attributes)
    fields = {
      name: "test#{counter(:domain)}.example.com",
      is_valid: true,
      user_id: user!.id
    }.merge(attributes)

    Domain.new(**fields)
  end

  def domain!(**a)
    domain(**a).tap &.save
  end

  def domain_with_hosts
    d = domain
  end
end
