-- +micrate Up
CREATE TABLE sent_notifications (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP,
  vendor_code INT default 0,
  reason_code INT default 0,
  updated_at TIMESTAMP
);
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
DROP TABLE sent_notifications;
-- SQL section 'Down' is executed when this migration is rolled back
