#!/bin/bash
#
# Remember docker-compose ports due to
# https://github.com/docker/compose/issues/4748.
#
set -e

RESULT=$(./scripts/docker-compose.sh ps)
echo "$RESULT"
CONTAINER_DRUPAL=$(echo "$RESULT" | grep _drupal_ | grep -o '^[-a-zA-Z0-9_]*')
{
  echo CONTAINER_DRUPAL="$CONTAINER_DRUPAL"
} > ./.docker-compose-info

source ./.env
EXTRA="./scripts/$CURRENT_TARGET_ENV/docker-compose-remember-info.source.sh"
if [ -f "$EXTRA" ]; then
  source "$EXTRA"
fi
