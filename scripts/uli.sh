#!/bin/bash
#
# Get a one-time login link to your development environment.
#

echo ''
echo ' => Drupal: '$(docker-compose exec drupal /bin/bash -c "drush -l http://$(docker-compose port drupal 80) uli")
echo " => Dummy email client: http://$(docker-compose port mail 8025)"
echo ''
