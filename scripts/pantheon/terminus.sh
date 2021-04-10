#!/bin/bash
#
# Call a drush command on a Pantheon environment.
#
set -e

BASE="$PWD"
source "$BASE"/scripts/pantheon/lib/terminus-preflight.source.sh

docker run --rm \
  -v "$HOME"/.ssh:/root/.ssh \
  -e PANTHEON_TOKEN="$PANTHEONTOKEN" \
  -e SSHKEYNOPASS=$PANTHEONSSHKEYNOPASSNAME \
  dcycle/terminus:2 "$@"
