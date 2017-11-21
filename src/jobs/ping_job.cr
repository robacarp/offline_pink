require "icmp"

class PingJob < Mosquito::QueuedJob
  params(check : Check | Nil)

  def perform
    puts "Pinging: Check##{check.id} #{check.host}"

    if hostname = check.host
      ip_addresses = Socket::Addrinfo.resolve(hostname, "http", type: Socket::Type::STREAM, protocol: Socket::Protocol::TCP).map(&.ip_address)

      results = ip_addresses.map do |a|
        next if a.address.includes? ":"
        statistics = ICMP::Ping.ping(a.address)
        PingResult.new(
          check_id: check.id,
          is_up: statistics[:success] > 0,
          response_time: statistics[:average_response]
        )
      end.compact

      results.each &.save
    end
  rescue e : Socket::Error
    PingResult.new(
      check_id: check.id,
      is_up: false,
      response_time: -1.0
    ).save
  end
end
