#!/bin/bash
#
# Initial setup of the code on a Docker Host environment.
#
set -e

source ./scripts/docker-host/lib/deploy-preflight.source.sh

echo "=> Running deploy script on the container"

ssh-agent bash -c "ssh-add $LOCALKEY; ssh $DOCKERHOSTUSER@$DOCKERHOSTIP 'cd $DOCKERHOSTDIR && ./scripts/docker-compose.sh exec -T drupal /bin/bash -c "'"'"drush $@"'"'"'"
