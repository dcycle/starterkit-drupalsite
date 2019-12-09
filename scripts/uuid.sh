#!/bin/bash
#
# Generate a UUID.
#
set -e

docker run --rm dcycle/drupal:8drush /bin/bash -c 'cat /proc/sys/kernel/random/uuid'
