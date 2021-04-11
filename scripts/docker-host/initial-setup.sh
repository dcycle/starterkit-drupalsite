#!/bin/bash
#
# Initial setup of the code on a Docker Host environment.
#
set -e

source ./scripts/docker-host/lib/initial-setup-preflight.source.sh

echo "=> Fetching code from git"

ssh-agent bash -c "ssh-add $LOCALKEY; ssh $DOCKERHOSTUSER@$DOCKERHOSTIP ''"
