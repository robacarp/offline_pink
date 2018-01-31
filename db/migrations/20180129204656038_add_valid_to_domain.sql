-- +micrate Up
ALTER TABLE domains
  ADD COLUMN is_valid BOOL not null default true;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE domains
  DROP COLUMN is_valid;
-- SQL section 'Down' is executed when this migration is rolled back
