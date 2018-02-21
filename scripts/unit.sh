#!/bin/bash
#
# Unit tests.
#
set -e

docker run -v "$(pwd)":/app phpunit/phpunit \
  --group myproject
