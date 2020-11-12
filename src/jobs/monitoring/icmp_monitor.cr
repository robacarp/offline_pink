require "icmp"

module Monitoring
  class Icmp < Base
    def check : Nil
      log "Pinging #{host.ip_address}"

      icmp = ICMP::Ping.new host.ip_address
      statistics = icmp.ping timeout: 2 do |_|
        # shhhhhh
      end

      if statistics[:success] == 1
        log "Ping time: #{statistics[:average_response]}"
        successful!

      else
        log "Ping failure."
        failed!

      end
    end

    def self.log_identifier
      "Ping Monitor"
    end
  end
end
