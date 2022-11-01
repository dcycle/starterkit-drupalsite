#!/bin/bash
#
# Push a build to the Docker Hub.
#
set -e

if [ -f .env ]; then
  source .env
fi

if [ "$CURRENT_TARGET_ENV" != "build" ]; then
  >&2 echo "You can only run push-build if the current target environment type is build. Run ./scripts/destroy.sh && ./scripts/deploy.sh build"
  >&2 echo ""
  exit 1
fi

if [ -z "$DOCKERHUBUSER" ] || [ -z "$DOCKERHUBPASS" ] || [ -z "$DOCKERHUBREPONAME" ] || [ -z "$DOCKERHUBREPOTAG" ]; then
  >&2 echo "Please make sure we know your Docker Hub credentials, the repo name and the tag, like this:"
  >&2 echo ""
  >&2 echo "export DOCKERHUBUSER=xxxx"
  >&2 echo "export DOCKERHUBPASS=xxxx"
  >&2 echo "export DOCKERHUBREPONAME=dcycle/drupal-starterkit # put yours instead."
  >&2 echo "export DOCKERHUBREPOTAG=mytagname"
  >&2 echo "./scripts/docker-hub/push-build.sh"
  >&2 echo ""
  exit 1
fi

MYIMAGE=$(docker inspect --format='{{.Config.Image}}' $(./scripts/docker-compose.sh ps -q drupal))
docker tag $MYIMAGE "$DOCKERHUBREPONAME":"$DOCKERHUBREPOTAG"
docker login -u"$DOCKERHUBUSER" -p"$DOCKERHUBPASS"
docker push "$DOCKERHUBREPONAME":"$DOCKERHUBREPOTAG"

echo ""
echo "All done!"
echo ""
echo "Your Drupal image should be available at https://hub.docker.com/r/$DOCKERHUBREPONAME/tags"
echo ""
