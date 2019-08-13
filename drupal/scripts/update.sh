#!/bin/bash
#
# Update an environment.
#
# This can be called when updating Acquia, or on local Docker environments
# from ./scripts/deploy.sh, in which case there are no arguments.
#
set -e

DRUSHENV="$1"
CONFIGLOCATION="$2"
if [ -z "$CONFIGLOCATION" ]; then
  CONFIGLOCATION=/var/www/config
fi

echo "[info] Make sure required directories exist and are empty."
rm -rf /tmp/localconfig
mkdir -p /tmp/localconfig
rm -rf /tmp/combinedconfig
mkdir -p /tmp/combinedconfig

# since Drush 9, $DRUSHENV cannot be in quotes.
drush $DRUSHENV updb -y
echo "[info] Loading config"
echo "[info] Start by exporting configuration which should be considered as"
echo "[info] data, that is which should not be deleted."
# See https://github.com/drush-ops/drush/issues/4052.
# See also ./drupal/settings/settings.php
drush $DRUSHENV cex -y dockerlocalconfig
echo "[info] Combine the config in code with the local config to keep."
cp "$CONFIGLOCATION"/* /tmp/combinedconfig/
echo "[info] We want to keep webforms the following webforms, not delete them:"
if ls /tmp/localconfig/webform.webform.* 1> /dev/null 2>&1; then
  ls -lah /tmp/localconfig/webform.webform.*
  cp /tmp/localconfig/webform.webform.* /tmp/combinedconfig/
  # Anything else you want to keep, like local blocks, can go here. Make sure
  # the same settings are in ./scripts/export-config.sh.
else
  echo "No webforms, moving on..."
fi
# Anything else you want to keep, like local blocks, can go here. Make sure
# the same settings are in ./scripts/export-config.sh.

drush $DRUSHENV cr
drush $DRUSHENV cim -y --source=/tmp/combinedconfig
echo "[info] Clearing cache"
drush $DRUSHENV cr

echo "User 1 should not be used in day-to-day operations, change its password"
echo "at every deployment (use drush $DRUSHENV uli to get a login link to user 1)"
drush $DRUSHENV upwd $(drush $DRUSHENV uinf --uid=1 --field=name) $RANDOM$RANDOM$RANDOM$RANDOM$RANDOM

echo "Run cron, try not to fail if there is no mailserver"
drush $DRUSHENV cron | true
