-- +micrate Up
ALTER TABLE domains ADD COLUMN status INT default -1;
ALTER TABLE hosts ADD COLUMN status INT default -1;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE domains DROP COLUMN status;
ALTER TABLE hosts DROP COLUMN status;
-- SQL section 'Down' is executed when this migration is rolled back
