class Monitors::SaveHTTP < Monitors::HTTP::SaveOperation
  permit_columns ssl, path, expected_status_code

  needs domain : Domain

  before_save do
    domain_id.value = domain.id
    region_id.value = Region.default_region.id
    validate_uniqueness_of domain_id
  end
end
