#!/bin/bash
#
# Get a one-time login link to your development environment.
#

echo ''
echo ' => '$(docker-compose exec drupal /bin/bash -c "drush -l http://$(docker-compose port drupal 80) uli")
echo ''
