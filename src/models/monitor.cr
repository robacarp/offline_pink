require "./monitor/*"

class Monitor < Granite::Base
  extend Granite::Query::BuilderMethods
  include HttpMonitor
  include IcmpMonitor

  adapter pg
  table_name :monitors

  belongs_to :domain
  has_many :monitor_results, class_name: MonitorResult

  field monitor_type : String

  field http_path : String
  field http_use_ssl : Bool
  field http_expected_status_code : Int32
  field http_expected_content : String

  timestamps

  VALID_TYPES = {
    :ping => "ping",
    :http => "http"
  }

  MESSAGES = {
    invalid_code: "Status code should be a number between 100 and 550",
    assigned:     "must be assigned",
    duplicate:    "is already being checked",
    blank:        "must be present",
    invalid_type: "Monitor type must be one of #{VALID_TYPES.values.join(", ")}"
  }

  def validate : Nil
    (add_error :domain, MESSAGES[:assigned]; return) unless @domain_id

    case @monitor_type
    when VALID_TYPES[:http]
      validate_http
    when VALID_TYPES[:ping]
      validate_icmp
    else
      add_error :base, MESSAGES[:invalid_type]
    end
  end

  def type
    VALID_TYPES.invert[monitor_type]
  end

  @last_result : MonitorResult?
  def last_result
    @last_result ||= begin
      if result = MonitorResult.where(monitor_id: id).order(created_at: :desc).first
        result
      else
        MonitorResult.new
      end
    end
  end

  def up?
    last_result.ok
  end

  def down?
    ! up?
  end
end
