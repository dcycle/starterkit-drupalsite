#!/bin/bash
#
# Remember docker-compose ports due to
# https://github.com/docker/compose/issues/4748.
#
set -e

CONTAINER_DRUPAL=$(./scripts/docker-compose.sh ps -q drupal)
{
  echo CONTAINER_DRUPAL="$CONTAINER_DRUPAL"
} > ./.docker-compose-info
CONTAINER_WEBSERVER=$(./scripts/docker-compose.sh ps -q webserver)
{
  echo CONTAINER_WEBSERVER="$CONTAINER_WEBSERVER"
} >> ./.docker-compose-info
source ./.env
EXTRA="./scripts/$CURRENT_TARGET_ENV/docker-compose-remember-info.source.sh"
if [ -f "$EXTRA" ]; then
  echo "SOURCING "$EXTRA
  source "$EXTRA"
fi
