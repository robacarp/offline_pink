require "icmp"

# class PingJob < Mosquito::QueuedJob
#   params(domain : Domain | Nil)
# 
#   @ip_addresses = [] of IpAddress
#   @status = :none
#   @alive = true
# 
#   def ping_result(**args) : PingResult
#     PingResult.new(**args, check_id: domain.id).tap do |result|
#       result.save
#       @alive &&= (result.is_up? || false)
#     end
#   end
# 
#   def invalidate_domain : Nil
#     domain.is_valid = false
#     domain.save
#   end
# 
#   def ensure_domain_exists
#     unless domain?
#       fail
#     end
#   end
# 
#   # TODO handle OpenSSL::SSL::Error: SSL_connect: error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed
#   def perform
#     ensure_domain_exists
#     log "Pinging: Domain##{domain.id} #{domain.name}"
#     resolve_hosts && send_pings
# 
#     case @status
#     when :success
#       log "Ping successful. #{@ip_addresses.size} addresses found."
#     when :no_name_present
#       log "Invalid domain"
#       invalidate_domain
#     when :no_host_present
#       log "Could not determine Hostname"
#       invalidate_domain
#     else
#       log "Non translatable status: #{@status}"
#     end
#   rescue e : Socket::Error
#     log "Socket Error while pinging domain"
#     invalidate_domain
#   ensure
#     unless @alive
#       # TODO hold onto and use the result object instead of querying it
#       # TODO don't send an email every time a check happens
#       # TODO DomainOfflineJob.new(result: domain.last_result).enqueue
#     end
#   end
# 
#   def resolve_hosts : Bool
#     unless name = domain.name
#       @status = :no_name_present
#       return false
#     end
# 
#     saved_addresses = domain.ip_addresses
# 
#     # Resolve a list of host addresses for the domain
#     hosts = Socket::Addrinfo.resolve(name, "http", type: Socket::Type::STREAM, protocol: Socket::Protocol::TCP).map(&.ip_address)
# 
#     log "Found #{hosts.size} hosts"
# 
#     hosts.each do |host|
#       log "found #{host}, saving"
#       # Search for each host address in the database
#       existing_address_index = saved_addresses.index do |ip_address|
#         host.address == ip_address.address
#       end
# 
#       # TODO handle when a host is removed from the domain
#       @ip_addresses << if existing_address_index
#         saved_addresses.delete_at(existing_address_index, 1).first
#       else
#         address = IpAddress.new domain_id: domain.id, address: host.address, version: "ipv4"
# 
#         if host.address.includes? ":"
#           log "not adding ipv6 address to database: #{host.address}"
#           next
#         end
# 
#         address.save
#         address
#       end
#     end
# 
#     true
#   end
# 
#   def send_pings
#     results = @ip_addresses.map do |a|
#       if a.v6?
#         log "Skipping ipv6 address #{a.address}"
#         next
#       end
# 
#       next unless address = a.address
# 
#       log "Pinging #{address}"
# 
#       statistics = ICMP::Ping.ping(address)
# 
#       ping_result(
#         is_up: statistics[:success] > 0,
#         ip_address_id: a.id,
#         response_time: statistics[:average_response]
#       )
#     end.compact.each &.save
# 
#     @status = :success
#     true
#   end
# 
#   def rescheduleable?
#     false
#   end
# end
