-- +micrate Up
DROP TABLE IF EXISTS checks;

-- +micrate Down
CREATE TABLE checks (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT,
  ping_check BOOL default false,
  get_request BOOL default false,
  host VARCHAR,
  url VARCHAR,
  uri VARCHAR default null,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX user_id_idx ON checks (user_id);
