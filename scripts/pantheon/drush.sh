#!/bin/bash
#
# Call a drush command on a Pantheon environment.
#
set -e

BASE="$PWD"
ENV="$1"
source "$BASE"/scripts/pantheon/lib/drush-preflight.source.sh

echo "drush $PANTHEONSITENAME.$ENV ${@:2}"
./scripts/pantheon/terminus.sh "drush -y $PANTHEONSITENAME.$ENV ${@:2}"
