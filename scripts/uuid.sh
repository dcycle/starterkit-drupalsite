#!/bin/bash
#
# Generate a UUID.
#
set -e

docker run --rm dcycle/drupal:10-fpm-alpine /bin/bash -c 'cat /proc/sys/kernel/random/uuid'
