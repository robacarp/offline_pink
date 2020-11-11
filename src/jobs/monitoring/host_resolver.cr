module Monitoring
  class HostResolver
    property hosts
    getter domain

    def self.lookup_hosts(domain : Domain)
      new(domain).tap(&.lookup_hosts)
    end

    def initialize(@domain : Domain)
      @hosts = [] of Host
      @missing_hosts = [] of Host
      @new_hosts = [] of Host
    end

    def lookup_hosts : Nil
      @hosts = Socket::Addrinfo.resolve(
        domain.name,
        "http",
        type: Socket::Type::STREAM,
        protocol: Socket::Protocol::TCP
      )
        .map(&.ip_address)
        .reject(&.unspecified?)
        .map {|address| Host.new address}

    rescue Socket::Error
      # cleverly do nothing
    end
  end
end
