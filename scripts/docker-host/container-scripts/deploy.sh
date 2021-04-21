#!/bin/bash
#
# Meant to be run on the container.
#
set -e

BASE="$(pwd)"

source "$BASE"/lib/deploy-preflight.source.sh

echo " ====> Making sure $DOCKERHOSTDIR exists with at least one deployment"

if [ -d "$DOCKERHOSTFULLDIR" ]; then
  echo "$DOCKERHOSTFULLDIR exists"
  echo "Making sure $DOCKERHOSTFULLDIR is on branch $GITBRANCH"
  cd $DOCKERHOSTFULLDIR
  git reset --hard
  git clean -df
  ssh-agent bash -c "ssh-add $DEPLOYKEY; git fetch"
  ssh-agent bash -c "ssh-add $DEPLOYKEY; git checkout $GITBRANCH"
  ssh-agent bash -c "ssh-add $DEPLOYKEY; git pull origin $GITBRANCH"
else
  cd $DOCKERHOSTPARENTDIR
  ssh-agent bash -c "ssh-add $DEPLOYKEY; git clone $GITREPO $DOCKERHOSTDIR"
  cd $DOCKERHOSTFULLDIR
  ssh-agent bash -c "ssh-add $DEPLOYKEY; git fetch"
  ssh-agent bash -c "ssh-add $DEPLOYKEY; git checkout $GITBRANCH"
  ssh-agent bash -c "ssh-add $DEPLOYKEY; git pull origin $GITBRANCH"
  ./scripts/deploy.sh
fi

echo " ====> Making sure $DOCKERHOSTDIR exists with at least one deployment"

sed -i "s/$DOCKERPREVHOSTDOMAIN/$DOCKERHOSTDOMAIN/" "$DOCKERHOSTFULLDIR/.env"

echo " ====> Updating the deployment."

./scripts/deploy.sh

echo " ====> Confirming the reverse proxy and LetsEncrypt are running"

source "$BASE"/lib/assert-reverse-proxy.source.sh

echo " ====> Updating the reverse proxy"

docker network connect "$DOCKERNETWORK" nginx-proxy
docker restart nginx-letsencrypt
