#!/bin/bash
#
# Make the starter database correspond to what's on your environment.
#
set -e

echo "[info] Remove cache tables which are not necessary."
docker-compose exec drupal /bin/bash -c 'echo "show tables" | drush sqlc | grep cache_ | xargs -I {} echo "truncate {};" | drush sqlc'
echo "[info] Export current state of database to disk."
docker-compose exec drupal /bin/bash -c 'drush sql-dump' > ./drupal/scripts/initial.sql
