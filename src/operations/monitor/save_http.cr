class Monitor::Http::Save < Monitor::Http::SaveOperation
  permit_columns ssl, path, expected_status_code

  needs domain : Domain

  getter meta_error : String = ""

  before_save do
    domain_id.value = domain.id
    region_id.value = Region.default_region.id

    validate_required ssl
    validate_required path
    # validate_inclusion_of expected_status_code, in: 100..500

    validate_inclusion_of ssl, in: [true, false]
  end
  
  before_save do
    puts "this executes twice"
  end

  before_save permit_only_one_domain_path_ssl_tuple

  def permit_only_one_domain_path_ssl_tuple
    return unless domain_id = domain.id
    return unless path_value = path.value
    return unless ssl_value = ssl.value

    results = Monitor::HttpQuery.new
      .domain_id(domain_id)
      .path(path_value)
      .ssl(ssl_value)
      .first?

    if results
      path.add_error "is already being checked"
      @meta_error = "Path & SSL must be unique -- only one monitor with a given path+ssl combination per domain."
    end
  end
end
