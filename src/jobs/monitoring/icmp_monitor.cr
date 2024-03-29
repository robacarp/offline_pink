require "icmp"

module Monitoring
  class Icmp < Base
    def check : Nil
      icmp = ICMP::Ping.new host.ip_address
      statistics = icmp.ping timeout: 2 do |_|
        # shhhhhh
      end

      if statistics[:success] == 1
        duration = Time::Span.new nanoseconds: (statistics[:average_response] * 1000000).to_i
        save_metric "icmp_response_time", duration

        log "∆t=#{format_time duration}"

      else
        save_failed_metric "response_time"
        log "failure.", LogEntry.error
        failed!

      end
    end
  end
end
