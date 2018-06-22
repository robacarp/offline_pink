-- +micrate Up
DROP TABLE IF EXISTS get_results;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
CREATE TABLE get_results (
  id BIGSERIAL PRIMARY KEY,
  is_up BOOL,
  response_time REAL,
  check_id BIGINT,
  response_code INT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  route_id BIGINT default null not null,
  found_expected_content BOOL default false
);

CREATE INDEX get_results_check_id_idx ON get_results (check_id);
-- SQL section 'Down' is executed when this migration is rolled back
