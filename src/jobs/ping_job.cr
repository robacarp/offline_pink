require "icmp"

class PingJob < Mosquito::QueuedJob
  params(domain : Domain | Nil)

  @hosts = [] of Socket::IPAddress
  @status = :none

  def ping_result(**args)
    PingResult.new(**args, check_id: domain.id).tap(&.save)
  end

  def perform
    puts "Pinging: Domain##{domain.id} #{domain.name}"
    resolve_hosts && send_pings

    case @status
    when :success
      puts "Ping successful. #{@hosts.size} addresses found."
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

    @hosts = Socket::Addrinfo.resolve(name, "http", type: Socket::Type::STREAM, protocol: Socket::Protocol::TCP).map(&.ip_address)
    true
  end

  def send_pings
    results = @hosts.map do |a|
      if a.address.includes? ":"
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
