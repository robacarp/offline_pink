#!/bin/bash

build_timestamp=$(date "+%Y-%m-%d %H:%M:%S" | tr -d '\n')

git_rev=$(git rev-parse HEAD | tr -d '\n')

git_tag=$(
  git tag -l "release-*" --sort=-version:refname \
    | head -n 1 \
    | tr -d '\n'
)
