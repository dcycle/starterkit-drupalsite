#!/bin/bash
#
# Make sure we can run a docker-compose command.
#
set -e

if [ -z "$TARGET_ENV" ]; then
  >&2 echo "TARGET_ENV variable must be set."
  exit 1
fi
CANDIDATE="./scripts/$TARGET_ENV/$1.source.sh"
if [ -f "$CANDIDATE" ]; then
  source "$CANDIDATE"
fi
