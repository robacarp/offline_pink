-- +micrate Up
TRUNCATE TABLE get_results;
ALTER TABLE get_results ADD COLUMN route_id BIGINT default null not null;
ALTER TABLE get_results ADD COLUMN found_expected_content BOOL default false;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE get_results DROP COLUMN route_id;
ALTER TABLE get_results DROP COLUMN found_expected_content;
-- SQL section 'Down' is executed when this migration is rolled back
