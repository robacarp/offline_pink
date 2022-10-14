FROM node:14-alpine3.14 AS frontend
WORKDIR /build

# yarn install dependencies
COPY package.json yarn.lock ./
RUN yarn install

# yarn run prod dependencies
COPY postcss.config.js tailwind.config.js .
COPY src/css src/css
COPY src/pages src/pages
COPY src/components src/components
COPY public/js public/js
RUN yarn run postcss src/css/app.css -o public/css/app.css

FROM crystallang/crystal:1.4.1-alpine-build

# bind-tools provides `dig` which is used to verify domain ownership.
RUN apk add cmake bind-tools

WORKDIR /build

# shards dependencies
COPY shard.yml shard.lock ./
ENV SKIP_LUCKY_TASK_PRECOMPILATION 1
RUN shards install --production

ENV DATABASE_URL postgresql://host.docker.internal/production
ENV REDIS_URL redis://host.docker.internal:6379
ENV LUCKY_ENV production
ENV SECRET_KEY_BASE 00000000000000000000000000000000
ENV PORT 3001
ENV SEND_GRID_KEY unused
ENV HOST 0.0.0.0
ENV FORCE_SSL true
ENV APP_DOMAIN http://localhost:3001

# Top level app files
COPY tasks.cr ./

# Top level app folders
COPY config ./config
COPY db ./db
COPY spec ./spec
COPY src ./src
COPY tasks ./tasks

# copy front end assets
COPY public/assets ./public/assets/
COPY public/robots.txt public/favicon.ico public/

# assume the assets have already been generated
# COPY public public/
COPY --from=frontend /build/public public/

RUN shards build #--release

# setup for execution
COPY script/docker/entrypoint /usr/local/bin/

# move everything into it's final place
WORKDIR /app
RUN cp -r /build/bin .
RUN cp -r /build/db .
RUN cp -r /build/public .

ARG build_timestamp
ARG git_rev
ARG git_tag

run echo -n '{ "build_timestamp": "' >  build_details.json
run echo -n "$build_timestamp"       >> build_details.json
run echo -n '", "git_revision": "'   >> build_details.json
run echo -n "$git_rev"               >> build_details.json
run echo -n '", "version": "'        >> build_details.json
run echo -n "$git_tag"               >> build_details.json
run echo -n '"}'                     >> build_details.json

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD []
