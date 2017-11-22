-- +micrate Up
ALTER TABLE checks
  ADD COLUMN uri VARCHAR default null;
UPDATE checks SET uri = concat(host, url);

-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE checks
  DROP COLUMN uri;
-- SQL section 'Down' is executed when this migration is rolled back
