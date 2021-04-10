#!/bin/bash
#
# Build Docker and move Items from Docker to Pantheon.
#
set -e

./scripts/deploy.sh
./scripts/pantheon/lib/update-from-docker.sh
