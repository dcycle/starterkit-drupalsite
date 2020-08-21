#!/bin/bash
#
# Get a Drupal shell
#
set -e

./scripts/docker-compose.sh exec drupal /bin/bash
