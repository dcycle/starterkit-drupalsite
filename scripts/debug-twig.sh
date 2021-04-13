#!/bin/bash
#
# Change the debug flag for Twig.
#
set -e

FROM=false
TO=true
if [ "$1" == 'false' ]; then
  FROM=true
  TO=false
fi

./scripts/docker-compose.sh exec -T drupal /bin/bash -c "sed -i 's/debug: $FROM/debug: $TO/g' /var/www/html/sites/default/services.yml && drush cr"
