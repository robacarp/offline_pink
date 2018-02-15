-- +micrate Up

DROP TABLE ping_results;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
CREATE TABLE ping_results (
  id BIGSERIAL PRIMARY KEY,
  is_up BOOL,
  response_time REAL,
  check_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX ping_results_check_id_idx ON ping_results (check_id);
-- SQL section 'Down' is executed when this migration is rolled back
