FROM crystallang/crystal:0.23.1

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y --no-install-recommends libpq-dev libsqlite3-dev libmysqlclient-dev libreadline-dev git curl

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

COPY config /offline-pink/config
COPY db /offline-pink/db
COPY public /offline-pink/public
COPY src /offline-pink/src
COPY support /offline-pink/support

COPY package.json /offline-pink
COPY package-lock.json /offline-pink

COPY shard.yml /offline-pink
COPY shard.lock /offline-pink

WORKDIR /offline-pink
RUN shards install
RUN npm install
RUN npm run release
RUN shards build worker --production
RUN shards build offline_pink --production

ENV AMBER_ENV production
ENV DATABASE_URL postgres://offline_pink:@docker.for.mac.localhost:5432/offline_pink_development

EXPOSE 3000

# Extract and copy the shared libraries that are needed to run the app
# https://gist.github.com/bcardiff/85ae47e66ff0df35a78697508fcb49af
# RUN ldd bin/offline_pink | tr -s '[:blank:]' '\n' | grep '^/' | \
#     xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'
# RUN ldd bin/worker | tr -s '[:blank:]' '\n' | grep '^/' | \
#     xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'
# 
# FROM scratch
# COPY --from=0 /offline-pink/deps /
# COPY --from=0 /offline-pink/bin /offline-pink/bin/

ENTRYPOINT ["/offline-pink/bin/offline_pink"]
