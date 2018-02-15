-- +micrate Up
CREATE TABLE monitor_results(
  id BIGSERIAL PRIMARY KEY,
  ip_address_id BIGINT NOT NULL,

  monitor_id BIGINT,
  monitor_type VARCHAR,

  -- the time the monitor was triggered
  run_start_time TIMESTAMP,
  run_finish_time TIMESTAMP,

  -- meta boolean about the state of the check
  ok BOOL,

  -- to signal that a monitor couldnt even connect to the address
  connect_failure BOOL,

  -- when the host lookup fails
  host_resolution_failure BOOL,

  -- when the address has been removed from the domain
  missing_host BOOL,

  -- for ping result
  ping_response_time REAL,

  -- for http result
  http_response_code INT,
  http_response_time REAL,
  http_content_found BOOL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX monitor_results_monitor_id_idx ON monitor_results (monitor_id);
CREATE INDEX monitor_results_ip_address_id_idx ON monitor_results (ip_address_id);


-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
DROP TABLE monitor_results;
-- SQL section 'Down' is executed when this migration is rolled back
