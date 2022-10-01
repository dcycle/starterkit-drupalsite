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

docker run --rm --network starterkit_drupalsite_default dcycle/pa11y:2 http://webserver -T 8
docker run --rm --network starterkit_drupalsite_default dcycle/pa11y:2 http://webserver/node/1 -T 7
docker run --rm --network starterkit_drupalsite_default dcycle/pa11y:2 http://webserver/dom-captures/user.html -T 12
docker run --rm --network starterkit_drupalsite_default dcycle/pa11y:2 http://webserver/dom-captures/node-1-edit.html -T 9

echo 'If this script passes, that means the number of errors is below the allowed threshold.'
