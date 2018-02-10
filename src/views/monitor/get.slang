| its a get!
br

| Path
= monitor.http_path
br

| SSL:
- if monitor.http_use_ssl
  | SSL!
- else
  | no ssl :<
br

| Status Code:
= monitor.http_expected_status_code
br

| Content:
= monitor.http_expected_content
