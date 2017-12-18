-- +micrate Up
TRUNCATE TABLE ping_results;
ALTER TABLE ping_results
  ADD COLUMN ip_address_id BIGINT default null not null;

-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE ping_results
  DROP COLUMN ip_address_id;
-- SQL section 'Down' is executed when this migration is rolled back

