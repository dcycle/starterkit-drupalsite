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
elif [ "$1" == 'webserver' ]; then
  echo "$CONTAINER_WEBSERVER"
else
  >&2 echo 'Please specify drupal or mail or webserver';
  exit 1
fi
