require "icmp"

class MonitorJob < Mosquito::QueuedJob
  params(domain : Domain | Nil)

  def perform
    log "Starting monitor for Domain##{present_domain.id} #{present_domain.name}"
    @start_time = Time.now
    lookup_hosts
    # if resolved?
    #   ip_addresses.each do |address|
    #     domain.monitors.each do |monitor|
    #       results = case monitor.monitor_type
    #       when Monitor::VALID_TYPES[:ping]
    #         check_ping address, monitor
    #       when Monitor::VALID_TYPES[:http]
    #         check_http address, monitor
    #       end
    #     end
    #   end
    # end
  ensure
    log "Finished monitor for Domain##{present_domain.id} #{present_domain.name}"
  end

  def rescheduleable?
    false
  end

  def present_domain
    domain.not_nil!
  end

  def domain_name!
    present_domain.name.not_nil!
  end

  def lookup_hosts : Array(Host)
    addresses = [] of Host

    resolved_hosts = Socket::Addrinfo.resolve(
      domain_name!,
      "http",
      type: Socket::Type::STREAM,
      protocol: Socket::Protocol::TCP
    ).map(&.ip_address)

    log "Found #{resolved_hosts.size} hosts:"
    resolved_hosts.map(&.address).each do |address|
      log "\t #{address}"
    end

    saved_hosts = present_domain.hosts

    log "Previously knew about #{saved_hosts.size} hosts:"
    saved_hosts.map(&.address).each do |address|
      log "\t #{address}"
    end

    new_hosts = resolved_hosts.reject {|host|  saved_hosts.map(&.address).includes? host.address }

    log "found #{new_hosts.size} new hosts:"
    new_hosts.map(&.address).each do |address|
      log "\t #{address}"
    end

    missing_hosts = saved_hosts.reject {|host| resolved_hosts.map(&.address).includes? host.address }

    log "#{missing_hosts.size} hosts are no longer resolving:"
    missing_hosts.map(&.address).each do |address|
      log "\t #{address}"
    end

    repeat_hosts = saved_hosts.reject {|host| ! resolved_hosts.map(&.address).includes? host.address }

    log "#{repeat_hosts.size} hosts have not changed:"
    repeat_hosts.map(&.address).each do |address|
      log "\t #{address}"
    end

    addresses = repeat_hosts

    new_hosts.each do |host|
      addresses << Host.new(domain_id: present_domain.id, address: host.address).tap(&.save)
    end

    addresses
  end

end
