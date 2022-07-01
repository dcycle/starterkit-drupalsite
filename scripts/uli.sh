#!/bin/bash
#
# Get a one-time login link to your development environment.
#
set -e

echo ''
echo ' => Drupal: '"$(docker-compose exec -T drupal /bin/bash -c "drush -l http://$(docker-compose port webserver 80) uli")"
source ./.env
export TARGET_ENV="$CURRENT_TARGET_ENV"
source ./scripts/lib/hook.source.sh uli
echo ''
