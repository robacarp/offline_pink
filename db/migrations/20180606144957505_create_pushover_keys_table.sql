-- +migrate Up

CREATE TABLE pushover_keys (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  key VARCHAR default null,
  verified BOOL default false,
  verification_code VARCHAR default null,
  verification_sent_at TIMESTAMP default null,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
-- SQL in section 'Up' is executed when this migration is applied

-- +migrate Down
DROP TABLE if exists pushover_keys;
-- SQL section 'Down' is executed when this migration is rolled back
