module SaveMonitor
  macro included
    needs domain : Domain

    getter meta_error : String = ""

    before_save do
      monitor_type.value = type.to_i
      config.value = monitor_config
      domain_id.value = domain.id
      region_id.value = Region.default_region.id
    end

    before_save ensure_uniqueness_of_monitor
  end

end

class SaveHttpMonitor < Monitor::SaveOperation
  include SaveMonitor

  attribute path : String
  attribute ssl : Bool
  attribute expected_status_code : Int32
  attribute expected_content : String

  before_save do
    validate_required path
    validate_inclusion_of expected_status_code, in: 100..599

    validate_required ssl
    validate_inclusion_of ssl, in: [true, false]
  end

  def type
    Monitor.http
  end

  def monitor_config
    Monitor::Http.new.tap do |http|
      if path_value = path.value
        http.path = path_value
      end

      if ssl_value = ssl.value
        http.ssl = ssl_value
      end

      if expected_status_code_value = expected_status_code.value
        http.expected_status_code = expected_status_code_value.to_i64
      end

      if expected_content_value = expected_content.value
        http.expected_content = expected_content_value
      end
    end.to_any
  end

  def ensure_uniqueness_of_monitor
    permit_only_one_domain_path_ssl_tuple
  end

  def permit_only_one_domain_path_ssl_tuple
    return unless domain_id = domain.id
    return unless path_value = path.value
    return unless ssl_value = ssl.value

    # UserQuery.new.preferences(JSON::Any.new({"theme" => JSON::Any.new("dark_mode")}))
    existing_monitor = MonitorQuery.new
     .monitor_type(type.to_i)
     .domain_id(domain_id)
     .config(JSON::Any.new({
      "path" => JSON::Any.new(path_value),
       "ssl" => JSON::Any.new(ssl_value)
     })).first?

    puts "options: ssl: #{ssl_value}, path: #{path_value}, domain: #{domain_id}"

    unless existing_monitor
      puts "no existing monitor found"
      return
    end

    monitor_config = existing_monitor.monitor_config

    return unless monitor_config.is_a? Monitor::Http

    puts "existing_record: ssl: #{monitor_config.ssl}, path: #{monitor_config.path}, domain: #{existing_monitor.domain_id}"

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

class SaveIcmpMonitor < Monitor::SaveOperation
  include SaveMonitor

  before_save do
    config.value = Monitor::Icmp.from_json("{}").to_any
    domain_id.value = domain.id
    region_id.value = Region.default_region.id
  end

  def type
    Monitor.icmp
  end

  def monitor_config
    Monitor::Icmp.from_json("{}").to_any
  end

  def ensure_uniqueness_of_monitor
    permit_only_one_monitor_per_domain
  end

  def permit_only_one_monitor_per_domain
    return unless domain_fk = domain.id

    results = MonitorQuery.new
      .domain_id(domain_fk)
      .monitor_type(type.to_i)
      .first?

    if results
      # this won't ever show, but is needed to fail the validations
      domain_id.add_error "is already being checked"
      @meta_error = "Only one ICMP monitor can be present for a domain"
    end
  end
end
