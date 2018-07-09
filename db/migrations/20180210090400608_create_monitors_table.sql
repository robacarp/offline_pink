-- +migrate Up
CREATE TABLE monitors(
  id BIGSERIAL PRIMARY KEY,
  domain_id BIGINT NOT NULL,

  monitor_type VARCHAR NOT NULL,

  http_use_ssl BOOL,
  http_path VARCHAR,
  http_expected_status_code INT,
  http_expected_content VARCHAR,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX monitors_domain_id_idx ON monitors (domain_id);

-- SQL in section 'Up' is executed when this migration is applied

-- +migrate Down
DROP TABLE monitors;
-- SQL section 'Down' is executed when this migration is rolled back
