#!/bin/bash
#
# Cache rebuild.
#
set -e

./scripts/docker-compose.sh exec drupal /bin/bash -c 'drush cr'
