#!/bin/bash
#
# Cache rebuild.
#
set -e

./scripts/docker-compose.sh exec -T drupal /bin/bash -c 'drush cr'
