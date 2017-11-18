require "socket"

TYPE = 8_u16
IP_HEADER_SIZE_8 = 20
PACKET_LENGTH_8 = 16
PACKET_LENGTH_16 = 8
MESSAGE = "ohai ICMP"

def ping
  sequence = 0_u16
  sender_id = 0_u16
  host = "8.8.8.8"

  # initialize packet with MESSAGE
  packet = Array(UInt16).new PACKET_LENGTH_16 do |i|
    MESSAGE[ i % MESSAGE.size ].ord.to_u16
  end

  # build out ICMP header
  packet[0] = (TYPE.to_u16 << 8)
  packet[1] = 0_u16
  packet[2] = sender_id
  packet[3] = sequence

  # calculate checksum
  checksum = 0_u32
  packet.each do |byte|
    checksum += byte
  end
  checksum += checksum >> 16
  checksum = checksum ^ 0xffff_ffff_u32
  packet[1] = checksum.to_u16

  # convert packet to 8 bit words
  slice = Bytes.new(PACKET_LENGTH_8)

  eight_bit_packet = packet.map do |word|
    [(word >> 8), (word & 0xff)]
  end.flatten.map(&.to_u8)

  eight_bit_packet.each_with_index do |chr, i|
    slice[i] = chr
  end

  # send request
  address = Socket::IPAddress.new host, 0
  socket = IPSocket.new Socket::Family::INET, Socket::Type::DGRAM, Socket::Protocol::ICMP
  socket.send slice, to: address

  # receive response
  buffer = Bytes.new(PACKET_LENGTH_8 + IP_HEADER_SIZE_8)
  count, address = socket.receive buffer
  length = buffer.size
  icmp_data = buffer[IP_HEADER_SIZE_8, length-IP_HEADER_SIZE_8]
end

ping
