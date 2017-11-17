-- +micrate Up
CREATE TABLE ping_results (
  id BIGSERIAL PRIMARY KEY,
  is_up BOOL,
  response_time REAL,
  check_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX ping_results_check_id_idx ON ping_results (check_id);

-- +micrate Down
DROP TABLE IF EXISTS ping_results;
