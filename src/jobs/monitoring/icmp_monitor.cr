require "icmp"

module Monitoring
  class Icmp < Base
    def check : Nil
      icmp = ICMP::Ping.new host.ip_address
      statistics = icmp.ping timeout: 2 do |_|
        # shhhhhh
      end

      if statistics[:success] == 1
        log "response time: #{statistics[:average_response]}"
        successful!

      else
        log "failure.", LogEntry.error
        failed!

      end
    end

    def log_identifier
      "ICMP Ping #{host.ip_address}"
    end
  end
end
