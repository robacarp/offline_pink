-- +micrate Up
CREATE TABLE hosts(
  id BIGSERIAL PRIMARY KEY,
  domain_id BIGINT NOT NULL,
  address VARCHAR NOT NULL DEFAULT null,
  ip_version VARCHAR NOT NULL DEFAULT null,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX hosts_domain_id_idx ON hosts (domain_id);
CREATE INDEX hosts_address_idx ON hosts (address);
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
DROP TABLE hosts;
-- SQL section 'Down' is executed when this migration is rolled back
