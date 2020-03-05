#!/bin/bash
#
# Make sure we can run a docker-compose command.
#
set -e

if [ -z "$TARGET_ENV" ]; then
  >&2 echo "TARGET_ENV variable must be set."
  exit 1
fi
if [ ! -f ./.env ]; then
  source ./scripts/lib/create-env.source.sh
fi
source ./.env
if [ "$CURRENT_TARGET_ENV" != "$TARGET_ENV" ]; then
  >&2 echo "Environments are not the same: $CURRENT_TARGET_ENV != $TARGET_ENV"
  >&2 echo "You cannot run a command for one environment ($TARGET_ENV) if"
  >&2 echo "Your current environment ($CURRENT_TARGET_ENV) is different."
  >&2 echo "You can destroy your current environemnt, using"
  >&2 echo ""
  >&2 echo " => ./scripts/destroy.sh"
  >&2 echo ""
  >&2 echo "Then run this command again."
  exit 1
fi
source ./.env
