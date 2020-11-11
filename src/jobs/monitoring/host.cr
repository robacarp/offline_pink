module Monitoring
  class Host
    property ip_address : String

    def initialize(@ip_address : String)
    end

    def initialize(socket_connector : Socket::IPAddress)
      initialize socket_connector.address
    end
  end
end
