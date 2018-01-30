-- +micrate Up
ALTER TABLE users
  ADD COLUMN admin BOOL default false not null;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE users
  DROP COLUMN admin;
-- SQL section 'Down' is executed when this migration is rolled back
