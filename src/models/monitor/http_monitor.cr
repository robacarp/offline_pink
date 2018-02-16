module HttpMonitor
  def validate_http
    enforce_leading_slash
    default_status_code
    clean_expected_content

    # status code shoud be a number 100-550
    (add_error :http_expected_status_code, Monitor::MESSAGES[:invalid_code]; return) if @http_expected_status_code.try { |c| ! (100 <= c < 550) }
    (add_error :http_path, Monitor::MESSAGES[:blank]; return) unless @http_path && ! @http_path.try(&.blank?)

    duplicate_monitors = Monitor.where(domain_id: @domain_id, monitor_type: Monitor::VALID_TYPES[:http])
                                .where(http_path: @http_path)
                                .where(http_use_ssl: @http_use_ssl)
                                .where(http_expected_status_code: @http_expected_status_code)
                                .where(http_expected_content: @http_expected_content)

    (add_error :monitor, Monitor::MESSAGES[:duplicate]; return) if duplicate_monitors.any?
  end

  def http_full_path
    "#{domain.name}#{http_path}"
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
