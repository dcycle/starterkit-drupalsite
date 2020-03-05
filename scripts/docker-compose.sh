#!/bin/bash
#
# Use this instead of docker-compose.
#

if [ -f .env ]; then
  source .env
fi
CANDIDATE="scripts/$CURRENT_TARGET_ENV/env.source.sh"
if [ -f "$CANDIDATE" ]; then
  source "$CANDIDATE"
fi
# Cannot quote $DOCKER_COMPOSE_FILES here
# shellcheck disable=SC2086
docker-compose $DOCKER_COMPOSE_FILES "$@"
