#!/bin/bash
# Rebuild script
# This is meant to be run on a regular basis to make sure everything works with
# the latest version of scripts.
set -e

./test.sh

CREDENTIALS="$HOME/.dcycle-docker-credentials.sh"

if [ ! -f "$CREDENTIALS" ]; then
  echo "Please create $CREDENTIALS and add to it:"
  echo "DOCKERHUBUSER=xxx"
  echo "DOCKERHUBPASS=xxx"
  exit;
else
  source "$CREDENTIALS";
fi

PROJECT=starterkit-drupalsite
DATE=`date '+%Y-%m-%d-%H-%M-%S-%Z'`
MAJORVERSION='1'
VERSION='1.0'

# See https://github.com/dcycle/prepare-docker-buildx, for M1 native images.
git clone https://github.com/dcycle/prepare-docker-buildx.git
cd prepare-docker-buildx
export DOCKER_CLI_EXPERIMENTAL=enabled
./scripts/run.sh
cd ..

docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx inspect --bootstrap
docker login -u"$DOCKERHUBUSER" -p"$DOCKERHUBPASS"

# Start by getting the latest version of the base images
docker pull php:7
docker pull php:8

docker buildx build -f="Dockerfile2" -t dcycle/"$PROJECT":"$VERSION" --platform linux/amd64,linux/arm64/v8 --push .
docker buildx build -f="Dockerfile2" -t dcycle/"$PROJECT":"$MAJORVERSION" --platform linux/amd64,linux/arm64/v8 --push .
docker buildx build -f="Dockerfile2" -t dcycle/"$PROJECT":"$MAJORVERSION".$DATE --platform linux/amd64,linux/arm64/v8 --push .
docker buildx build -f="Dockerfile2" -t dcycle/"$PROJECT":"$VERSION".$DATE --platform linux/amd64,linux/arm64/v8 --push .

MAJORVERSION='3'
VERSION='3.0'

docker buildx build -f="Dockerfile3" -t dcycle/"$PROJECT":"$VERSION" --platform linux/amd64,linux/arm64/v8 --push .
docker buildx build -f="Dockerfile3" -t dcycle/"$PROJECT":"$MAJORVERSION" --platform linux/amd64,linux/arm64/v8 --push .
docker buildx build -f="Dockerfile3" -t dcycle/"$PROJECT":"$MAJORVERSION".$DATE --platform linux/amd64,linux/arm64/v8 --push .
docker buildx build -f="Dockerfile3" -t dcycle/"$PROJECT":"$VERSION".$DATE --platform linux/amd64,linux/arm64/v8 --push .
