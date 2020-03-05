#!/bin/bash
#
# Destroy all trace of this project.
# Meant for use with source ...
#
set -e

echo ''
echo '-----'
echo 'Ensuring the integrity of the .env file.'
source ./scripts/lib/assert-env.source.sh

# Cannot quote $DOCKER_COMPOSE_FILES here
# shellcheck disable=SC2086
docker-compose $DOCKER_COMPOSE_FILES down -v --remove-orphans
# On certain systems like CircleCI we won't have permission to remove these,
# this is not a show-stopper.
rm -rf ./do-not-commit 2>/dev/null || echo "Could not remove ./do-not-commit; use sudo?"
rm -rf ./.docker-compose-info
