-- +micrate Up
ALTER TABLE users ADD COLUMN features INT default 0;
ALTER TABLE users DROP COLUMN admin;
ALTER TABLE users DROP COLUMN activated;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE users DROP COLUMN features;
ALTER TABLE users ADD COLUMN admin BOOL default false not null;
ALTER TABLE users ADD COLUMN activated BOOL default false;
-- SQL section 'Down' is executed when this migration is rolled back
