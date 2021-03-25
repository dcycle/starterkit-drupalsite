#!/bin/bash
#
# Unit tests.
#
set -e

docker run --rm -v "$(pwd)":/app dcycle/phpunit:1 \
  --group myproject
