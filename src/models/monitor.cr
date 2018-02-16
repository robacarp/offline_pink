require "./monitor/*"

class Monitor < Granite::ORM::Base
  extend Query::BuilderMethods
  include HttpMonitor
  include IcmpMonitor

  adapter pg

  belongs_to :domain

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
    blank:        "must be present"
  }

  def validate : Nil
    (add_error :domain, MESSAGES[:assigned]; return) unless @domain_id

    case @monitor_type
    when VALID_TYPES[:http]
      validate_http
    when VALID_TYPES[:ping]
      validate_icmp
    end
  end

  def type
    VALID_TYPES.invert[monitor_type]
  end
end
