require "icmp"

class PingJob < Mosquito::QueuedJob
  params(domain : Domain | Nil)

  @ip_addresses = [] of IpAddress
  @status = :none
  @alive = true

  def ping_result(**args) : PingResult
    PingResult.new(**args, check_id: domain.id).tap do |result|
      result.save
      @alive &&= (result.is_up? || false)
    end
  end

  def ensure_domain_exists
    unless domain?
      fail
    end
  end

  def perform
    ensure_domain_exists
    puts "Pinging: Domain##{domain.id} #{domain.name}"
    resolve_hosts && send_pings

    case @status
    when :success
      puts "Ping successful. #{@ip_addresses.size} addresses found."
    when :no_name_present
      puts "Invalid domain"
    when :no_host_present
      puts "Could not determine Hostname"
      ping_result is_up: false
    else
      puts "Non translatable status: #{@status}"
    end

  rescue e : Socket::Error
    ping_result is_up: false
  ensure
    unless @alive
      # TODO hold onto and use the result object instead of querying it
      # TODO don't send an email every time a check happens
      DomainOfflineJob.new(result: domain.last_result).enqueue
    end
  end

  def resolve_hosts : Bool
    unless name = domain.name
      @status = :no_name_present
      return false
    end

    saved_addresses = domain.ip_addresses

    # Resolve a list of host addresses for the domain
    hosts = Socket::Addrinfo.resolve(name, "http", type: Socket::Type::STREAM, protocol: Socket::Protocol::TCP).map(&.ip_address)

    hosts.each do |host|
      # Search for each host address in the database
      existing_address_index = saved_addresses.index do |ip_address|
        host.address == ip_address.address
      end

      # TODO handle when a host is removed from the domain
      @ip_addresses << if existing_address_index
        saved_addresses.delete_at(existing_address_index, 1).first
      else
        address = IpAddress.new domain_id: domain.id, address: host.address, version: "ipv4"
        address.version = "ipv6" if host.address.includes? ":"
        address.save
        address
      end
    end

    true
  end

  def send_pings
    results = @ip_addresses.map do |a|
      if a.v6?
        puts "Skipping ipv6 address #{a.address}"
        next
      end

      next unless address = a.address

      puts "Pinging #{address}"

      statistics = ICMP::Ping.ping(address)

      ping_result(
        is_up: statistics[:success] > 0,
        ip_address_id: a.id,
        response_time: statistics[:average_response]
      )
    end.compact.each &.save

    @status = :success
    true
  end
end
