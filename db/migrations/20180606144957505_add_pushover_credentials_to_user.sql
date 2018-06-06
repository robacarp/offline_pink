-- +micrate Up
ALTER TABLE users ADD COLUMN pushover_key VARCHAR default null;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE users DROP COLUMN pushover_key;
-- SQL section 'Down' is executed when this migration is rolled back
