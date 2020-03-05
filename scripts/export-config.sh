#!/bin/bash
#
# Export configuration.
#

set -e

docker exec "$(./scripts/docker-compose-container.sh drupal)" /bin/bash -c \
  "drush cex -y deploy"

# We consider certain items to be data whereas Drupal considers them to
# be configuration. Data should not be exported to the codebase so remove
# those items here.
# Anything else you want to ignore, like local blocks, can go here. Make sure
# the same settings are in ./drupal-server/scripts/deploy.sh.
# echo '[info] Webforms are data, not config, so remove them from git...'
# rm drupal-server/config/webform.webform.*
# echo '[info] Webforms have been removed from git but will still exist'
# echo '[info] as content in your source database.'
