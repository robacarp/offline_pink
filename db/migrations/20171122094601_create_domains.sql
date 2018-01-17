-- +micrate Up
CREATE TABLE domains (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  name VARCHAR NOT NULL default null,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX domains_user_id_idx ON domains (user_id);

-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
DROP TABLE domains;
-- SQL section 'Down' is executed when this migration is rolled back
