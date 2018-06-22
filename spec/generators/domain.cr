module Generate
  def self.domain(**attributes)
    fields = {
      name: "test#{counter(:domain)}.example.com",
      is_valid: true,
      user_id: user!.id
    }.merge(attributes)

    Domain.new(**fields)
  end

  def self.domain!(**a)
    domain(**a).tap &.save
  end
end
