class HostResolver
  property hosts, missing_hosts, new_hosts

  def self.lookup_hosts(domain : Domain)
    new(domain).tap(&.lookup_hosts)
  end

  def initialize(@domain : Domain)
    @hosts = [] of Host
    @missing_hosts = [] of Host
    @new_hosts = [] of Host
  end

  def lookup_hosts : Nil
    resolved_hosts = Socket::Addrinfo.resolve(
      @domain.name.not_nil!,
      "http",
      type: Socket::Type::STREAM,
      protocol: Socket::Protocol::TCP
    ).map(&.ip_address)

    saved_hosts = @domain.hosts

    new_hosts = resolved_hosts.reject {|host|  saved_hosts.map(&.address).includes? host.address }

    missing_hosts = saved_hosts.reject {|host| resolved_hosts.map(&.address).includes? host.address }

    repeat_hosts = saved_hosts.reject {|host| ! resolved_hosts.map(&.address).includes? host.address }

    @hosts = repeat_hosts
    @missing_hosts = missing_hosts
    @new_hosts = new_hosts.map do |host|
      Host.new(domain_id: @domain.id, address: host.address).tap(&.save)
    end

    @hosts += @new_hosts
  end

end
