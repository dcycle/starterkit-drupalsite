#!/bin/bash
#
# Import configuration.
#

set -e

docker compose exec -T drupal /bin/bash -c \
  "/scripts/deploy.sh"
