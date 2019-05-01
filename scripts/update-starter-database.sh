#!/bin/bash
#
# Make the starter database correspond to what's on your environment.
#
set -e

echo " => Truncating cache tables for a smaller footprint."
docker-compose exec drupal /bin/bash -c 'echo "show tables" | drush sqlc | grep cache_ | xargs -I {} echo "truncate {};" | drush sqlc'
echo " => Updating starter db."
docker-compose exec drupal /bin/bash -c 'drush sql-dump' > ./drupal/scripts/initial.sql
echo " => Done updating starter db."
