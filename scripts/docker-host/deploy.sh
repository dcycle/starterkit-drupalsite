#!/bin/bash
#
# Initial setup of the code on a Docker Host environment.
#
set -e

source ./scripts/docker-host/lib/deploy-preflight.source.sh

echo "=> Running deploy script on the container"

ssh-agent bash -c "ssh-add $LOCALKEY; ssh $DOCKERHOSTUSER@$DOCKERHOSTIP 'rm -rf ~/container-scripts'"
ssh-agent bash -c "ssh-add $LOCALKEY; scp -r $BASE/scripts/docker-host/container-scripts $DOCKERHOSTUSER@$DOCKERHOSTIP:~/container-scripts"
ssh-agent bash -c "ssh-add $LOCALKEY; ssh $DOCKERHOSTUSER@$DOCKERHOSTIP 'export ENV=$ENV && \
  export DEPLOYKEY=$DEPLOYKEY && \
  export GITREPO=$GITREPO && \
  export GITBRANCH=$GITBRANCH && \
  export DOCKERHOSTPARENTDIR=$DOCKERHOSTPARENTDIR && \
  export DOCKERHOSTDOMAIN=$DOCKERHOSTDOMAIN && \
  export DOCKERNETWORK=$DOCKERNETWORK &&\
  export DOCKERHOSTDIR=$DOCKERHOSTDIR && \
  cd ~/container-scripts && \
  ./deploy.sh'"
