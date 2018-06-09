class MonitorResult < Granite::Base
  extend Granite::Query::BuilderMethods

  adapter pg

  belongs_to :domain
  belongs_to :host
  belongs_to :monitor

  field monitor_type : String

  field run_start_time : Time
  field run_finish_time : Time

  field ok : Bool

  field host_resolution_failure : Bool
  field connect_failure : Bool
  field missing_host : Bool

  field ping_response_time : Float32

  field http_response_code : Int32
  field http_response_time : Float32
  field http_content_found : Bool

  timestamps

  VALID_TYPES = {
    :ping => "ping",
    :http => "http",
    :host => "host"
  }

  def ok?
    ok
  end

  def matching_result_set
    self.class.where(run_start_time: run_start_time, host_id: host_id)
  end
end
