struct Response
  getter http_status : HTTP::Status
  getter status_code : Int32
  getter body : String

  getter raw : HTTP::Client::Response
  getter hard_fail : Bool
  getter soft_fail : Bool

  def self.from(response : HTTP::Client::Response)
    new(response).tap do |r|
      puts r

      puts "==========================================="
      puts r.body
      puts "==========================================="
    end
  end

  def initialize(response : HTTP::Client::Response)
    @raw = response
    @http_status = response.status
    @body = response.body
    @hard_fail = false
    @soft_fail = false
    @status_code = -1

    case http_status.to_i
    when 200
    when 400..499
      @hard_fail = true
    else # when 500
      @soft_fail = true
    end

    parsed = JSON.parse body
    @status_code = parsed["status"].as_i
  end

  def success : Bool
    http_status == HTTP::Status::OK && status_code == 1
  end

  # responses:
  # token: invalid -- application token is invalid
  # user: invalid  -- user token is invalid
  # status: 1 -- everything went well

  def to_s(io : IO)
    io << "<Response http status:"
    io << http_status
    io << " api status:"
    io << status_code
    io << ">"
  end
end
