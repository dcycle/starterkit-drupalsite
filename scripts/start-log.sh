#!/bin/bash
#
# Start the rsyslog. During local development, the rsyslog service can die.
# Use this to restart it, which is faster than running ./scripts/deploys.sh.
# See the "Logging" section of ./README.md.
#
set -e

docker-compose exec drupal /bin/bash -c 'service rsyslog start'
