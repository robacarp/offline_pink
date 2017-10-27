-- +micrate Up
CREATE TABLE checks (
  id BIGSERIAL PRIMARY KEY,
  type VARCHAR,
  reference VARCHAR,
  user_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX user_id_idx ON checks (user_id);

-- +micrate Down
DROP TABLE IF EXISTS checks;
