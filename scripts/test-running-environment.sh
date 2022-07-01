#!/bin/bash
#
# Run some checks on a running environment
#
set -e

echo " => Displaying status report for info"
./scripts/docker-compose.sh exec -T drupal /bin/bash -c "drush status-report"
echo " => Making sure we do not have incompatible modules"
./scripts/docker-compose.sh exec -T drupal /bin/bash -c "! (drush status-report --severity=2 | grep Incompatible)"

echo " => Done running self-tests."
echo " =>"
