-- +migrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR,
  email VARCHAR,
  crypted_password VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +migrate Down
DROP TABLE IF EXISTS users;
