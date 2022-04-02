#!/bin/bash
#
# Run end-to-end tests and keep track of markup and screenshots.
#

set -e

USER=admin
PASS=$(./scripts/uuid.sh)
echo 'Updating password for admin so our testbot knows how to login'
docker exec "$(./scripts/docker-compose-container.sh drupal)" /bin/bash -c 'drush upwd $(drush uinf --uid=1 --field=name) '"$PASS"

echo 'Running our tests'
docker run -e DRUPALUSER=admin -e DRUPALPASS="$PASS" --rm -v "$(pwd)"/tests/browser-tests:/app/test \
  --network starterkit_drupalsite_default \
  -v "$(pwd)"/do-not-commit/screenshots:/artifacts/screenshots \
  -v "$(pwd)"/do-not-commit/dom-captures:/artifacts/dom-captures \
  dcycle/browsertesting:3

BASE="$(pwd)"
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * "
echo " SEE YOUR SCREENSHOTS IN"
echo " $BASE/do-not-commit/screenshots/*"
echo " AND"
echo " $BASE/do-not-commit/dom-captures/*"
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * "
