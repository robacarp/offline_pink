class Monitor::Http::Save < Monitor::Http::SaveOperation
  permit_columns ssl, path, expected_status_code, expected_content

  needs domain : Domain

  getter meta_error : String = ""

  before_save do
    domain_id.value = domain.id
    region_id.value = Region.default_region.id

    validate_required ssl
    validate_required path
    validate_inclusion_of expected_status_code, in: 100..599

    validate_inclusion_of ssl, in: [true, false]
  end

  before_save permit_only_one_domain_path_ssl_tuple

  def permit_only_one_domain_path_ssl_tuple
    return unless domain_id = domain.id
    return unless path_value = path.value
    return unless ssl_value = ssl.value

    existing_monitor = Monitor::HttpQuery.new
      .domain_id(domain_id)
      .path(path_value)
      .ssl(ssl_value)
      .first?

    return unless existing_monitor

    puts "options: ssl: #{ssl_value}, path: #{path_value}, domain: #{domain_id}"
    puts "existing_record: ssl: #{existing_monitor.ssl}, path: #{existing_monitor.path}, domain: #{existing_monitor.domain_id}"

    if existing_monitor
      path.add_error "is already being checked"
      @meta_error = "Path & SSL must be unique -- only one monitor with a given path+ssl combination per domain."
    end
  end

  # broken in avram master
  # ported from:
  # https://github.com/luckyframework/avram/blob/master/src/avram/validations.cr#L102-L104
  def validate_inclusion_of(attribute, in allowed_values : Range, allow_nil : Bool = false)
    nil_message = "is required"
    range_message = "must be between #{allowed_values.begin} and #{allowed_values.end}"

    value = attribute.value
    if value.nil?
      attribute.add_error nil_message unless allow_nil
      return
    end

    unless allowed_values.includes? value
      attribute.add_error range_message
    end
  end
end
