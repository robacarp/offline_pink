FROM robacarp/amber_build:latest

WORKDIR .
COPY package.json .
RUN npm install

COPY config ./config
COPY db ./db
COPY public ./public
COPY src ./src

COPY shard.yml .
COPY shard.lock .
COPY app.json .

COPY Procfile .
COPY DOCKER_OPTIONS_RUN .
COPY DOCKER_OPTIONS_BUILD .

RUN shards install
RUN npm run release

RUN shards build offline_pink worker --production
RUN setcap cap_net_raw+ep bin/worker

ENV AMBER_ENV production
ENV DATABASE_URL postgres://offline_pink:@docker.for.mac.localhost:5432/offline_pink_development
ENV REDIS_URL redis://docker.for.mac.localhost:6379/1

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

ENTRYPOINT ["/bin/sh","-c"]
CMD ["bin/offline_pink"]
