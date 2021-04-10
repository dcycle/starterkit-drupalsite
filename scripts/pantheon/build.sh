#!/bin/bash
#
# Build the Pantheon code from our code.
#
set -e

BASE="$PWD"
source "$BASE"/scripts/pantheon/lib/build-preflight.source.sh

PANTHEONREPO="$BASE"/do-not-commit/pantheon

echo "=> Removing $PANTHEONREPO"
rm -rf "$PANTHEONREPO"

echo "=> Cloning a new copy of $PANTHEONREPO"
mkdir -p "$BASE"/do-not-commit
cd "$BASE"/do-not-commit && ssh-agent bash -c "ssh-add $PANTHEONSSHKEY; git clone --tags $PANTHEONGIT pantheon"

echo "=> Determining build tag"
cd "$BASE"
TAG=`date +%Y-%m-%d-`$(git rev-parse --short HEAD)"-"$RANDOM
echo "Build tag is $TAG"

./scripts/pantheon/lib/build-from-docker.sh

echo "=> Pushing to pantheon"
cd "$PANTHEONREPO"
echo '{ "tag" : "'"$TAG"'" }' > "$PANTHEONREPO"/version.json
git add .
git commit -am "Updated to build $TAG (do not modify this repo manually, see README)" | true
git tag "$TAG"
ssh-agent bash -c "ssh-add $PANTHEONSSHKEY; git push origin master --tags"

cd "$BASE"
./scripts/pantheon/update.sh dev
