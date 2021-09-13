# the.offline.pink

## Stack
 - [Lucky](https://luckyframework.org) API Backend, Sever Side Rendering.
 - [Mosquito](https://github.com/mosquito-cr/mosquito) Job runner, redis backed.
 - [apexcharts](https://apexcharts.com) Interactive frontend charts.
 - Some light javascript for frontend interactivity.

## Setting up and development

1. Needs Postgres 13 and Redis server.
1. [asdf](https://asdf-vm.com/) .tool-versions file provides crystal and node development versioning.
1. [Install lucky cli](https://luckyframework.org/guides/getting-started/installing)
1. Run `script/setup`:
  - Installs crystal dependencies.
  - Installs node packages via yarn.
  - Creates, migrates, and seeds the database.
1. `lucky dev` will start backend server and frontend assets worker.
1. `script/worker` will build and run the monitoring worker -- the worker does not hot-reload.

## Deployment

- `script/docker/build` assembles a docker container locally, and tags it as `offline_pink`.
- `script/docker/deploy` tags for heroku, pushes the container, and releases both web and worker.
- `heroku run bin/tasks db.migrate` to run a database migration container.
