FROM node:14.15.4-alpine3.12 AS frontend
WORKDIR /node-build

# yarn install dependencies
COPY package.json yarn.lock ./
RUN yarn install

# yarn run prod dependencies
ENV PARCEL_WORKERS=1
COPY postcss.config.js bs-config.js tailwind.config.js /
COPY src/js src/js
COPY src/css src/css
COPY src/_entrypoint.html src/
RUN yarn run prod

FROM crystallang/crystal:0.35.1-alpine-build
WORKDIR /crystal-build

# shards dependencies
COPY shard.yml shard.lock ./
ENV SKIP_LUCKY_TASK_PRECOMPILATION 1
RUN shards install

# copy over crystal code
COPY tasks.cr ./

COPY config ./config
COPY db ./db
COPY spec ./spec
COPY src ./src
COPY tasks ./tasks

# copy front end assets
COPY public/assets ./public/assets/
COPY public/mix-manifest.json public/robots.txt public/favicon.ico public/
COPY --from=frontend /node-build/public public/

RUN shards build --production

# setup for execution
COPY script/docker/entrypoint /usr/local/bin/
ENV DATABASE_URL postgresql://host.docker.internal/production
ENV REDIS_URL redis://host.docker.internal:6379
ENV LUCKY_ENV production
ENV SECRET_KEY_BASE 00000000000000000000000000000
ENV PORT 3001
ENV SEND_GRID_KEY unused
ENV HOST 0.0.0.0
ENV APP_DOMAIN http://localhost:3001

# move everything into it's final place
WORKDIR /app
RUN cp -r /crystal-build/bin .
RUN cp -r /crystal-build/config .
RUN cp -r /crystal-build/db .
RUN cp -r /crystal-build/public .

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD []
