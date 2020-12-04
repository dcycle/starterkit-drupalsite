#!/bin/bash
#
# Test one Drupal class on a running container. See ./README.md.
#
set -e

if [ -z "$1" ]; then
  >&2 echo 'Please specify a class such as "Drupal\Tests\locale\Functional\LocalePluralFormatTest"; see ./README.md for details.'
  exit 1
fi

./scripts/docker-compose.sh exec drupal /bin/bash -c 'mkdir -p sites/default/files/simpletest && chown -R www-data:www-data sites/default/files/simpletest && drush en -y simpletest && php core/scripts/run-tests.sh --verbose --class "'"$1"'"'
