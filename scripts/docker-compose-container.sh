#!/bin/bash
#
# Get a previously remembered docker-compose container.
#
set -e

if [ ! -f ./.docker-compose-info ]; then
  ./scripts/docker-compose-remember-info.sh
fi

source ./.docker-compose-info

if [ "$1" == 'drupal' ]; then
  echo "$CONTAINER_DRUPAL"
elif [ "$1" == 'mail' ]; then
  echo "$CONTAINER_MAIL"
else
  >&2 echo 'Please specify drupal or mail';
  exit 1
fi
