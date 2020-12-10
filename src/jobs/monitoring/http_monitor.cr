module Monitoring
  class Http < Base
    # TODO prevent big pages from taking down the worker? Limit to 1KB or so?
    # TODO handle OpenSSL::SSL::Error: SSL_connect: error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed

    @domain : Domain?

    private def monitor : Monitor::Http
      if (mon = @monitor) && mon.is_a? Monitor::Http
        mon
      else
        raise "#{self.class.name} unexpectedly received a #{monitor.class.name}"
      end
    end

    private def domain : Domain
      @domain ||= monitor.domain!
    end

    def check : Nil
      url = "#{protocol}#{host.ip_address}#{monitor.path}"
      headers = HTTP::Headers{ "Host" => "#{domain.name}" }


      response : HTTP::Client::Response

      client = http_client(host.ip_address)

      start_time = Time.monotonic
      response = client.get monitor.path, headers
      response_time = Time.monotonic - start_time

      log "GET #{domain.name} via #{url} => #{response.status_code}, ∆t=#{format_time response_time}"

      if response.status_code != monitor.expected_status_code
        log "Expected status #{monitor.expected_status_code} but got #{response.status_code}"
        result.failed!
      end

      if search_string = monitor.expected_content
        unless response.body.lines.join(" ").index search_string
          log "Plain text search for '#{monitor.expected_content}' failed"
          result.failed!
        end
      end

      result.successful!

      # result
      # rescue err : Errno
      # case err.errno
      # when Errno::ECONNREFUSED
      #   log "http connection refused"
      # when Errno::ETIMEDOUT
      #   log "http connection timed out"
      # else
      #   log "http check failed with errno #{err.errno}"
      # end
    end

    def protocol
      if monitor.ssl?
        "https://"
      else
        "http://"
      end
    end

    def http_client(ip_address : String) : HTTP::Client
      client = if monitor.ssl?
        tls_config = OpenSSL::SSL::Context::Client.new
        tls_config.verify_mode = OpenSSL::SSL::VerifyMode::NONE

        HTTP::Client.new "#{ip_address}", tls: tls_config
      else
        HTTP::Client.new "#{ip_address}"
      end

      client.connect_timeout = 2
      client.read_timeout = 2
      client
    end

    def log_identifier
      "HTTP"
    end
  end
end
