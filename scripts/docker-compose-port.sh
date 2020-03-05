#!/bin/bash
#
# Get a previously remembered docker-compose port.
#
set -e

if [ ! -f ./.docker-compose-info ]; then
  ./scripts/docker-compose-remember-info.sh
fi

source ./.docker-compose-info

docker port "$(./scripts/docker-compose-container.sh "$1")" "$2"
