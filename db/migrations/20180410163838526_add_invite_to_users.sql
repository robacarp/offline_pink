-- +micrate Up
ALTER TABLE users
  ADD COLUMN invite_id BIGINT default null;

ALTER TABLE users
  ADD COLUMN activated BOOL default false;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE users DROP COLUMN activated;
ALTER TABLE users DROP COLUMN invite_id;
-- SQL section 'Down' is executed when this migration is rolled back
