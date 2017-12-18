require "icmp"

class PingJob < Mosquito::QueuedJob
  params(domain : Domain | Nil)

  @ip_addresses = [] of IpAddress
  @status = :none

  def ping_result(**args)
    PingResult.new(**args, check_id: domain.id).tap(&.save)
  end

  def perform
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
      puts "Non translateable status: #{@status}"
    end

  rescue e : Socket::Error
    ping_result is_up: false
  end

  def resolve_hosts : Bool
    unless name = domain.name
      @status = :no_name_present
      return false
    end

    saved_addresses = domain.ip_addresses

    hosts = Socket::Addrinfo.resolve(name, "http", type: Socket::Type::STREAM, protocol: Socket::Protocol::TCP).map(&.ip_address)
    p hosts
    hosts.each do |host|
      existing_address_index = saved_addresses.index do |ip_address|
        host.address == ip_address.address
      end

      @ip_addresses << if existing_address_index
        saved_addresses.delete_at(existing_address_index, 1).first
      else
        address = IpAddress.new domain_id: domain.id, address: host.address, version: "ipv4"
        address.version = "ipv6" if host.address.includes? ":"
        address.save
      end
    end

    true
  end

  def send_pings
    return
    results = @ip_addresses.map do |a|
      if a.v4?
        puts "Skipping ipv6 address #{a.address}"
        next
      end

      puts "Pinging #{a.address}"

      statistics = ICMP::Ping.ping(a.address)

      ping_result(
        is_up: statistics[:success] > 0,
        ip_address: a.address,
        response_time: statistics[:average_response]
      )
    end.compact.each &.save

    @status = :success
    true
  end
end
