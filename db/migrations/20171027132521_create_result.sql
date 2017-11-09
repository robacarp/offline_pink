-- +micrate Up
CREATE TABLE results (
  id BIGSERIAL PRIMARY KEY,
  is_up BOOL,
  response_time REAL,
  check_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX check_id_idx ON results (check_id);

-- +micrate Down
DROP TABLE IF EXISTS results;
