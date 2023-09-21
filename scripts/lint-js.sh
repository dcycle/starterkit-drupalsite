#!/bin/bash
#
# Lint Javascript.
#
set -e

# See https://github.com/dcycle/docker-js-lint
docker run --rm -v "$(pwd)"/drupal:/app/code dcycle/js-lint:3 .
