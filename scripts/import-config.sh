#!/bin/bash
#
# Import configuration.
#

set -e

docker compose exec drupal /bin/bash -c \
  "/scripts/deploy.sh"
