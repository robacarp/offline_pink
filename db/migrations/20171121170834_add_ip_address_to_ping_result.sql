-- +micrate Up
ALTER TABLE ping_results
  ADD COLUMN ip_address VARCHAR default null;

TRUNCATE TABLE ping_results;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE ping_results
  DROP COLUMN ip_address;
-- SQL section 'Down' is executed when this migration is rolled back
