class Monitor < Granite::ORM::Base
  extend Query::BuilderMethods
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

  def validate : Nil
    messages = {
      invalid_code: "Status code should be a number between 100 and 550",
      assigned:     "must be assigned",
      duplicate:    "is already being checked",
      blank:        "must be present"
    }

    (add_error :http_expected_domain, messages[:assigned]; return) unless @domain_id

    if @monitor_type == VALID_TYPES[:http]
      enforce_leading_slash
      default_status_code
      clean_expected_content

      # status code shoud be a number 100-550
      (add_error :http_expected_status_code, messages[:invalid_code]; return) if @http_expected_status_code.try { |c| ! (100 <= c < 550) }
      (add_error :http_path, messages[:blank]; return) unless @http_path && ! @http_path.try(&.blank?)

      duplicate_monitors = Monitor.where(domain_id: @domain_id, monitor_type: VALID_TYPES[:http])
                                  .where(http_path: @http_path)
                                  .where(http_use_ssl: @http_use_ssl)
                                  .where(http_expected_status_code: @http_expected_status_code)
                                  .where(http_expected_content: @http_expected_content)

      (add_error :monitor, messages[:duplicate]; return) if duplicate_monitors.any?
    end
  end

  def type
    VALID_TYPES.invert[monitor_type]
  end

  private def default_status_code
    if @http_expected_status_code.nil? || @http_expected_status_code == 0
      @http_expected_status_code = 200
    end
  end

  private def enforce_leading_slash
    if http_path = @http_path
      if http_path.blank?
        @http_path = "/"
      elsif http_path[0] != '/'
        @http_path = "/" + http_path
      end
    end
  end

  private def clean_expected_content
    if expected_content = @http_expected_content
      if expected_content.blank?
        @http_expected_content = nil
      end
    end
  end
end
