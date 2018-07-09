-- +migrate Up
DROP TABLE ip_addresses;
-- SQL in section 'Up' is executed when this migration is applied

-- +migrate Down
CREATE TABLE ip_addresses(
  id BIGSERIAL PRIMARY KEY,
  domain_id BIGINT NOT NULL,
  address VARCHAR NOT NULL DEFAULT null,
  version VARCHAR NOT NULL DEFAULT null,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX ip_addresses_domain_id_idx ON ip_addresses (domain_id);
-- SQL section 'Down' is executed when this migration is rolled back
