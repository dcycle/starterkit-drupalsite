#!/bin/bash
#
# Javascript unit tests.
#
set -e

# See https://github.com/dcycle/docker-ava
docker run --rm \
  -v "$(pwd)"/tests/js-unit-tests:/app/code \
  -v "$(pwd)"/drupal:/mycode \
  dcycle/ava:3
