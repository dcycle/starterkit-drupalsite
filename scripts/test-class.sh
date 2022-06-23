#!/bin/bash
#
# Test one Drupal class on a running container. See ./README.md.
#
set -e

if [ -z "$1" ]; then
  >&2 echo 'Please specify a class such as "Drupal\Tests\locale\Functional\LocalePluralFormatTest"; see ./README.md for details.'
  exit 1
fi

./scripts/docker-compose.sh exec -T --user www-data drupal /bin/bash -c 'php core/scripts/run-tests.sh --verbose --class "'"$1"'"'
