#!/bin/bash
#
# Make the starter database correspond to what's on your environment.
#
set -e

docker-compose exec drupal /bin/bash -c 'drush sql-dump' > ./drupal/scripts/initial.sql
