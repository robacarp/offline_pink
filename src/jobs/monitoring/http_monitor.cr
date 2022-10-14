module Monitoring
  class Http < Base
    # TODO prevent big pages from taking down the worker? Limit to 1KB or so?
    # TODO handle OpenSSL::SSL::Error: SSL_connect: error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed

    @domain : Domain?

    private def domain : Domain
      @domain ||= monitor.domain!
    end

    def port
      # TODO allow manually specifying the port
      if config.ssl?
        443
      else
        80
      end
    end

    def headers : HTTP::Headers
      HTTP::Headers{
        "Host" => domain.name
        # TODO "Accept-Encoding" => "gzip, deflate"
      }
    end

    def tls_config
      OpenSSL::SSL::Context::Client.new.tap do |context|
        context.verify_mode = OpenSSL::SSL::VerifyMode::NONE
      end
    end

    # TODO what are sane values for read_timeout, write_timeout, connect_timeout
    def with_connected_io
      tcp_socket = TCPSocket.new host.ip_address, port#, connect_timeout: 5
      # tcp_socket.write_timeout = 2
      # tcp_socket.read_timeout = 2
      tcp_socket.sync = false

      if config.ssl?
        ssl_layer = OpenSSL::SSL::Socket::Client.new(
          tcp_socket,
          context: tls_config,
          sync_close: true,
          hostname: domain.name
        )

        response = yield ssl_layer
        # TODO log ssl details
        response
      else
        yield tcp_socket
      end
    ensure
      if socket = tcp_socket
        socket.close
      end
    end

    # TODO allow method to be specified
    def method
      "GET"
    end

    def run_request : HTTP::Client::Response
      with_connected_io do |io|
        request = HTTP::Request.new method, config.path, headers
        request.to_io io
        io.flush

        # decompress: true when Accept-Encoding is set to gzip/deflate
        HTTP::Client::Response.from_io io#, decompress: true
      end
    end

    def config : Monitor::Http
      if (monitor_config = monitor.monitor_config).is_a? Monitor::Http
        monitor_config
      else
        raise "#{self.class.name} unexpectedly received a #{monitor_config.class.name}"
      end
    end

    def check : Nil
      response : HTTP::Client::Response

      start_time = Time.monotonic
      response = run_request
      response_time = Time.monotonic - start_time

      save_metric "http_response_time", response_time

      log "GET #{protocol}#{domain.name}#{config.path} => #{response.status_code}, ∆t=#{format_time response_time}"

      if response.status_code != config.expected_status_code
        log "Expected status #{config.expected_status_code} but got #{response.status_code}", LogEntry.error
        save_metric "http_status_code", response.status_code, units: "http_status_code", success: false
        failed!
      else
        save_metric "http_status_code", response.status_code, units: "http_status_code"
      end

      # todo scrape:
      # response.charset
      # response.content_type
      # response.mime_type
      # response.version
      # response body compression algorithms

      if search_string = config.expected_content
        unless response.body.lines.join(" ").index search_string
          log "Plain text search for '#{config.expected_content}' failed", LogEntry.error
          failed!
        end
      end

    # rescue e : OpenSSL::SSL::Error
    #   log "SSL error"

    #   if message = e.message
    #     log message
    #   end

    #   failed!

      # ▸ Job failed! Raised OpenSSL::SSL::Error: SSL_connect: error:14094438:SSL routines:ssl3_read_bytes:tlsv1 alert internal error

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
      if config.ssl?
        "https://"
      else
        "http://"
      end
    end
  end
end
