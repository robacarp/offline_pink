require "openssl"
require "http"

# io = IO::Memory.new
# client_context = OpenSSL::SSL::Context::Client.new

# OpenSSL::SSL::Socket::Client.open(io, client_context, hostname: "robacarp.io") do |client|
#   puts client.peer_certificate
# end


# https://github.com/crystal-lang/crystal/blob/41573fadb/src/http/client.cr#L787-L814

dns_name = "robacarp.io"
ip_address = "37.16.5.143"
port = 443

tls_config = OpenSSL::SSL::Context::Client.new
tls_config.verify_mode = OpenSSL::SSL::VerifyMode::NONE

headers = HTTP::Headers{
  "Host" => dns_name,
  "User-Agent" => "Crystal",
  "Accept-Encoding" => "gzip, deflate"
}

tcp_socket = TCPSocket.new(ip_address, port)
tcp_socket.sync = false

ssl_layer = OpenSSL::SSL::Socket::Client.new(
  tcp_socket,
  context: tls_config,
  sync_close: true,
  hostname: dns_name
)

# todo don't leak the TCP socket when the SSL connection failed
#ssl_layer.as(IO)

request = HTTP::Request.new("GET", "/", headers)
request.to_io(ssl_layer)
ssl_layer.flush

response = HTTP::Client::Response.from_io ssl_layer, decompress: true

puts "response headers: "
pp response.headers

puts "ssl client configuration:"
puts "\tmodes: #{tls_config.modes}"
puts "\toptions: #{tls_config.options}"
puts "\tsecurity_level: #{tls_config.security_level}"
puts "\tverify_mode: #{tls_config.verify_mode}"

certificate = ssl_layer.peer_certificate
puts "x509 cert:"
puts "\tsubject: #{certificate.subject.to_a}"
puts "\textensions: "
certificate.extensions.each do |extension|
  puts "\t\t#{extension.oid} => #{extension.value}"
end

puts "\tsignature_algorithm: #{certificate.signature_algorithm}"
