struct APILimits
  property app_limit : Int32
  property remaining_sends : Int32
  property reset_time : Time

  def self.from(response : HTTP::Client::Response)
    app_limit = (response.headers["X-Limit-App-Limit"]? || -1).to_i
    remaining_sends = (response.headers["X-Limit-App-Remaining"]? || -1).to_i
    reset_time = Time.unix (response.headers["X-Limit-App-Reset"]? || 0).to_i

    new app_limit, remaining_sends, reset_time
  end

  def initialize(@app_limit, @remaining_sends, @reset_time)
  end

  def update
  end

  def self.can_send? : Bool
    true
  end

  def to_s(io : IO)
    io << "<Response "
    io << status_code
    io << " "
    io << remaining_sends
    io << " pushes remaining until "
    io << reset_time
    io << ">"
  end
end
