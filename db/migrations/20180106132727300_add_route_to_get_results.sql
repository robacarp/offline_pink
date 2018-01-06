-- +micrate Up
TRUNCATE TABLE get_results;
ALTER TABLE get_results
  ADD COLUMN route_id BIGINT default null not null;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE get_results
  DROP COLUMN route_id;
-- SQL section 'Down' is executed when this migration is rolled back
