#!/bin/bash
#
# Update the dev environment on Pantheon.
#
set -e

BASE="$PWD"
ENV="$1"
source "$BASE"/scripts/pantheon/lib/update-preflight.source.sh

echo "=> Clearing cache (1)"
./scripts/pantheon/drush.sh "$ENV" cr
echo "=> Importing config"
./scripts/pantheon/drush.sh "$ENV" -y cim
echo "=> Updb"
./scripts/pantheon/drush.sh "$ENV" -y updb
echo "=> Cron"
./scripts/pantheon/drush.sh "$ENV" cron
echo "=> Clearing cache (2)"
./scripts/pantheon/drush.sh "$ENV" cr
echo "=> All done updating $ENV"
