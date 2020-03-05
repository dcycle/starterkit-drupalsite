#!/bin/bash
#
# Import configuration.
#

set -e

docker exec "$(./scripts/docker-compose-container.sh drupal)" /bin/bash -c \
  "/scripts/deploy.sh"
