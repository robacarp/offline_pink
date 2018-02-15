-- +micrate Up
DROP TABLE routes;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
CREATE TABLE routes(
  id BIGSERIAL PRIMARY KEY,
  domain_id BIGINT NOT NULL,
  path VARCHAR NOT NULL DEFAULT null,
  expected_content VARCHAR,
  expected_code BIGINT,
  use_ssl BOOL DEFAULT true,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX routes_domain_id_idx ON routes (domain_id);

-- SQL section 'Down' is executed when this migration is rolled back
