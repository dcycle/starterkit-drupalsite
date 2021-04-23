#!/bin/bash
#
# Static analysis.
#
set -e

# See https://github.com/dcycle/docker-phpstan-drupal.
docker run --rm \
  -v "$(pwd)"/drupal/custom-modules:/var/www/html/modules/custom \
  -v "$(pwd)"/scripts/lib/phpstan:/phpstan-drupal \
  dcycle/phpstan-drupal:3 /var/www/html/modules/custom \
  -c /phpstan-drupal/phpstan.neon
