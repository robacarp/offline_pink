-- +micrate Up
ALTER TABLE domains ADD COLUMN status_code INT default -1;
ALTER TABLE hosts ADD COLUMN status_code INT default -1;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE domains DROP COLUMN status_code;
ALTER TABLE hosts DROP COLUMN status_code;
-- SQL section 'Down' is executed when this migration is rolled back
