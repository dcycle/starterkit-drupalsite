#!/bin/bash
#
# Run accessitility tests.
#
set -e

if [ ! -f ./do-not-commit/dom-captures/user.html ]; then
  >&2 echo 'Please run ./scripts/end-to-end-tests.sh first to get DOM captures'
  >&2 echo 'of internal pages.'
  exit 1
fi

docker run --rm --network starterkit_drupal8site_default dcycle/pa11y:1 http://drupal -T 6
docker run --rm --network starterkit_drupal8site_default dcycle/pa11y:1 http://drupal/node/1 -T 6
docker run --rm --network starterkit_drupal8site_default dcycle/pa11y:1 http://drupal/dom-captures/user.html -T 10
docker run --rm --network starterkit_drupal8site_default dcycle/pa11y:1 http://drupal/dom-captures/node-1-edit.html -T 10
