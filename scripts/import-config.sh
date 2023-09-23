#!/bin/bash
#
# Import configuration.
#

set -e

docker exec "$(docker compose ps -q drupal)" /bin/bash -c \
  "/scripts/deploy.sh"
