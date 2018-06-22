-- +migrate Up
CREATE TABLE invites (
  id BIGSERIAL PRIMARY KEY,
  code VARCHAR,
  uses_remaining BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +migrate Down
DROP TABLE IF EXISTS invites;
